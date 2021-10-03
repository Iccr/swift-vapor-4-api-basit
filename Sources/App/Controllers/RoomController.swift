//
//  File.swift
//  
//
//  Created by ccr on 01/10/2021.
//

import Foundation
import Fluent
import Vapor

struct RoomController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
    }
    
    func index(req: Request) throws -> EventLoopFuture<[Room]> {
        return Room.query(on: req.db).all()
    }
    
    //    func create(req: Request) throws -> EventLoopFuture<Room> {
    //        struct Entity: Content {
    //                var images: File
    //        }
    //        let room = try req.content.decode(Room.self)
    //        let file = try req.content.decode(Entity.self)
    //        let image = file.images
    //        let uploadPath = req.application.directory.publicDirectory + "uploads/"
    //        let filename = "\(Date().timeIntervalSince1970)_" + image.filename.replacingOccurrences(of: " ", with: "")
    //
    //        return req.fileio.writeFile(
    //            image.data,
    //            at:  uploadPath + filename
    //        ).flatMap {
    //            room.vimages = [filename]
    //           return room.save(on: req.db).map {
    //            room
    //           }
    //        }
    //    }
    
    func create(req: Request) throws -> EventLoopFuture<Room> {
        struct Entity: Content {
            var images: [File]
        }
        let uploadPath = req.application.directory.publicDirectory + "uploads/"
        
        let room = try req.content.decode(Room.self)
        let file = try req.content.decode(Entity.self)
        return file.images.map { file -> EventLoopFuture<String> in
            let filename = "\(Date().timeIntervalSince1970)_" + file.filename.replacingOccurrences(of: " ", with: "")
            return req.fileio.writeFile(file.data, at: uploadPath + filename ).map { filename }
            
        }.flatten(on: req.eventLoop).map { filenames in
            room.vimages = filenames
        }.flatMap { _ in
            return room.save(on: req.db).map {room}
        }
    }
}
