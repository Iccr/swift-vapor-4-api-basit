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
        print(req.parameters)
        
        let params = try req.query.decode(Room.Querry.self)
        return City.query(on: req.db)
            .with(\.$rooms)
            .filter(\.$id == (params.city_id ?? -1))
            .first()
            .flatMap { city in
                if let city = city {
                    let query =  city.$rooms.query(on: req.db)
                    return querries(query: query, params: params).all()
                }else {
                    let query =
                    Room.query(on: req.db)
                        .with(\.$city)
                    return querries(query: query, params: params).all()
                }
            }
    }
    
    func querries(query: QueryBuilder<Room>, params: Room.Querry) -> QueryBuilder<Room> {
        
        if let val = params.type {
            query.filter(\.$type ~~ val)
        }
        if let val = params.kitchen {
            query.filter(\.$kitchen ~~ val)
        }
        if let val = params.floor {
            query.filter(\.$floor ~~ val)
        }
        
        if let val = params.address {
            query.filter(\.$address ~~ val)
        }
        
        if let val = params.district {
            query.filter(\.$district ~~ val)
        }
        
        if let val = params.state {
            query.filter(\.$state ~~ val)
        }
        
        if let val = params.localGov {
            query.filter(\.$localGov ~~ val)
        }
        
        if let val = params.parking {
            query.filter(\.$parking ~~ val)
        }
        
        if let val = params.water {
            query.filter(\.$water ~~ val)
        }
        
        if let val = params.internet {
            query.filter(\.$internet ~~ val)
        }
        
        if let val = params.preference {
            query.filter(\.$preference ~~ val)
        }
        
        
        if let val = params.lowerPrice {
            query.filter(\.$price >= val)
        }
        
        if let val = params.upperPrice {
            query.filter(\.$price <= val)
        }
//        query
//            .filter(\.$price >= (params.lowerPrice ?? 1_00_000))
//            .filter(\.$price <= (params.upperPrice ?? 0))
        return query
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
    
    func create(req: Request) throws -> EventLoopFuture<Room.Output> {
        let user: User = try req.auth.require(User.self)
        struct Entity: Content {
            var images: [File]
            var city_id: Int
        }
        let uploadPath = req.application.directory.publicDirectory + "uploads/"
        let room = try req.content.decode(Room.self)
        let input = try req.content.decode(Entity.self)
        
        return input.images.map { file -> EventLoopFuture<String> in
            let filename = "\(Date().timeIntervalSince1970)_" + file.filename.replacingOccurrences(of: " ", with: "")
            return req.fileio.writeFile(file.data, at: uploadPath + filename ).map { filename }
        }.flatten(on: req.eventLoop).map { filenames in
            room.vimages = filenames
        }.flatMap { _ in
            return City.query(on: req.db)
                .filter(\.$id == input.city_id)
                .first()
        }.flatMap { city in
            //            guard let city = _city else {throw Abort(.notFound, reason: "City not found")}
            
//            room = user.id
            room.$user.id = user.id ?? -1
            room.$city.id = city?.id ?? -1
            
            return room.create(on: req.db).map {
                return room.responseFrom(baseUrl: req.baseUrl)
            }
        }
    }
}
