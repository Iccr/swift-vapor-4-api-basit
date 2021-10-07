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
        let query = try req.query.decode(Room.Querry.self)
        return RoomStore().getAllRooms(query, req: req)
    }
    
    
    func create(req: Request) throws -> EventLoopFuture<Room.Output> {
        let user: User = try req.auth.require(User.self)
        let room = try req.content.decode(Room.self)
        let input = try req.content.decode(Room.Entity.self)
        return RoomStore().create(req: req, room: room, input: input, user: user)
        
    }
    
    func show(req: Request) throws -> EventLoopFuture<Room.Output>  {
        return  try RoomStore().getWithId(req: req)
//        return 
    }
}
