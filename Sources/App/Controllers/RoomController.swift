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
    
    func create(req: Request) throws -> EventLoopFuture<Room> {
        struct Entity: Content {
                var images: File
        }
        let room = try req.content.decode(Room.self)
        let file = try req.content.decode(Entity.self)
        let image = file.images
        let uploadPath = req.application.directory.publicDirectory + "uploads/"
        let filename = "\(Date().timeIntervalSince1970)_" + image.filename.replacingOccurrences(of: " ", with: "")
        
        let uploadFutures = input.files
                .filter { $0.data.readableBytes > 0 }
                .map { file -> EventLoopFuture<UploadedFile> in
                    let fileName = prefix + file.filename
                    let path = app.directory.publicDirectory + fileName
                    let isImage = ["png", "jpeg", "jpg", "gif"].contains(file.extension?.lowercased())
                    
                    return req.application.fileio.openFile(path: path,
                                                           mode: .write,
                                                           flags: .allowFileCreation(posixMode: 0x744),
                                                           eventLoop: req.eventLoop)
                        .flatMap { handle in
                            req.application.fileio.write(fileHandle: handle,
                                                         buffer: file.data,
                                                         eventLoop: req.eventLoop)
                                .flatMapThrowing { _ in
                                    try handle.close()
                                    return UploadedFile(url: fileName, isImage: isImage)
                                }
                            
                        }
                }
        
        return req.fileio.writeFile(
            image.data,
            at:  uploadPath + filename
        ).flatMap {
            room.vimages = [filename]
           return room.save(on: req.db).map {
            room
           }
        }
//      return  req.fileio.writeFile(file.data, at: path).map {Room()}
     
//        print(images?.count)
        
//            return room.create(on: req.db).map { room }
    }

//    func create(req: Request) throws -> EventLoopFuture<Todo> {
//        print(req.body)
//        print(req.content)
//        print(req.method)
//        print(req.parameters)
//        let todo = try req.content.decode(Todo.self)
//        print(todo.title)
//        return todo.save(on: req.db).map { todo }
//    }
//
//    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        return Todo.find(req.parameters.get("todoID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { $0.delete(on: req.db) }
//            .transform(to: .ok)
//    }
}
