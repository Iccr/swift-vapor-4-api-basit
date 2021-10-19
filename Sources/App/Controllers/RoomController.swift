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
    
    func index(req: Request) throws -> EventLoopFuture<CommonResponse<Page<Room.Output>>> {
        let query = try req.query.decode(Room.Querry.self)
        return RoomStore().getAllRooms(query, req: req)
            .map(CommonResponse.init)
        
    }
    
    
    func create(req: Request) throws -> EventLoopFuture<CommonResponse<Room.Output>> {
        req.logger.log(level: .critical, "creating rooms")
        req.logger.log(level: .critical, "looking for authenticated user")
        let user: User = try req.auth.require(User.self)
        req.logger.log(level: .critical, "found user: \(user)")
        req.logger.log(level: .critical, "decoding room from post body")
        let room = try req.content.decode(Room.self)
        req.logger.log(level: .critical, "decoded room: \(room)")
        req.logger.log(level: .critical, "decoding  Room.Entity as input")
        let input = try req.content.decode(Room.Entity.self)
        req.logger.log(level: .critical, "decoded  input: \(input)")
        
        return try RoomStore().create(req: req, room: room, input: input, user: user)
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
    
    func update(req: Request)  throws -> EventLoopFuture<CommonResponse<Room.Output>>  {
        let input = try req.content.decode(Room.Update.self)
        return try RoomStore().update(req: req, input: input).map(CommonResponse.init)
    }
}
