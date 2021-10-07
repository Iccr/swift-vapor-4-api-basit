//
//  File.swift
//  
//
//  Created by ccr on 07/10/2021.
//

import Foundation
import Vapor
import Fluent

class RoomStore {
    
    
    
    func getAllRooms(_ searchQuery: Room.Querry, req: Request) -> EventLoopFuture<[Room]> {
        City.query(on: req.db)
            .with(\.$rooms)
            .filter(\.$id == (searchQuery.city_id ?? -1))
            .first()
            .flatMap { city in
                if let city = city {
                    let query =  city.$rooms.query(on: req.db)
                    return self.querries(query: query, params: searchQuery).all()
                }else {
                    let query =
                    Room.query(on: req.db)
                        .with(\.$city)
                    return self.querries(query: query, params: searchQuery).all()
                }
            }
    }
    
    func create(req: Request, room: Room, input: Room.Entity, user: User ) ->  EventLoopFuture<Room.Output> {
        let uploadPath = req.application.directory.publicDirectory + "uploads/"
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
    
    func getWithId(req: Request) throws -> EventLoopFuture<Room.Output> {
        if let _id = req.parameters.get("id"), let id = Int(_id) {
            return Room.find(id, on: req.db).flatMapThrowing { room in
                if let room = room {
                    return room.responseFrom(baseUrl: req.baseUrl)
                }
                throw Abort(.notFound)
                
            }
        }
        throw Abort(.notFound)
        
    }
    
    
}


extension RoomStore {
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
}
