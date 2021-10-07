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
    
    func index(req: Request) throws -> EventLoopFuture<CommonResponse<[Room.Output]>> {
        let query = try req.query.decode(Room.Querry.self)
        return RoomStore().getAllRooms(query, req: req).map(CommonResponse.init)
        
    }
    
    
    func create(req: Request) throws -> EventLoopFuture<CommonResponse<Room.Output>> {
        let user: User = try req.auth.require(User.self)
        let room = try req.content.decode(Room.self)
        let input = try req.content.decode(Room.Entity.self)
        return RoomStore().create(req: req, room: room, input: input, user: user)
            .map(CommonResponse.init)
    }
    
    func show(req: Request) throws -> EventLoopFuture<CommonResponse<Room.Output>>  {
        return  try RoomStore().getWithId(req: req)
            .map(CommonResponse.init)
    }
    
    func getMyRooms(req: Request) throws -> EventLoopFuture<CommonResponse<[Room.Output]>> {
        let user: User = try req.auth.require(User.self)
        return  RoomStore().getMyRooms(req: req, user: user)
            .map(CommonResponse.init)
    }
}
