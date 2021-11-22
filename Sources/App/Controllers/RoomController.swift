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
        let route = routes.grouped("rooms")
        let secure = routes.grouped(UserAuthenticator()).grouped(User.guardMiddleware())
        
        route.get(":id", use: show)
        route.get( use: index)
        secure.patch("rooms", use: update)
        secure.get("myRooms", use: getMyRooms)
        secure.post("rooms", use: create)
    }
    
    func index(req: Request)  throws -> EventLoopFuture<CommonResponse<Page<Room.Output>>> {
        let query = try req.query.decode(Room.Querry.self)
        return  RoomStore().getAllRooms(query, req: req)
            .map(CommonResponse.init)
        
    }
    
    func create(req: Request) throws -> EventLoopFuture<CommonResponse<Room.Output>> {
        
        return try RoomStore().create(req: req)
            .map(CommonResponse.init)
    }
    
    func show(req: Request) throws -> EventLoopFuture<CommonResponse<Room.Output>>  {
        return  try RoomStore().getWithId(req: req)
            .map(CommonResponse.init)
    }
    
    func getMyRooms(req: Request) throws -> EventLoopFuture<CommonResponse<Page<Room.Output>>> {
        let user: User = try req.auth.require(User.self)
        return  RoomStore().getMyRoomsWithPagination(req: req, user: user)
            .map(CommonResponse.init)
    }
    
    func update(req: Request)  throws -> EventLoopFuture<CommonResponse<Room.Output>>  {
        let input = try req.content.decode(Room.Update.self)
        return try RoomStore().update(req: req, input: input).map(CommonResponse.init)
    }
}
