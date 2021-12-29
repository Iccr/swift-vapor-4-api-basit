//
//  File.swift
//  
//
//  Created by ccr on 10/10/2021.
//

import Foundation
import Vapor
import Fluent

class RoomWebController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let rooms = routes.grouped("rooms")
        let secureRooms = rooms
            .grouped(
                User.redirectMiddleware(path: "/?loginRequired=true")
            )
        let secureRoutes = routes
            .grouped(
                User.redirectMiddleware(path: "/?loginRequired=true"))
        rooms.get(use: index) // /rooms
//        rooms.post( use: create)
        secureRooms.post("destroy", use: destroy) // /rooms/destroy
        secureRoutes.get("myrooms", use: showMyRooms) // /myrooms
        secureRoutes.get("profile", use: showProfile) // /profile
//        secureRooms.get("new", use: new) i// rooms/new
        secureRooms.get("edit", ":id", use: edit) // rooms/edit/1
        secureRooms.post(":id", use: update) // rooms/edit/1
    }
    
    func index(req: Request) throws -> EventLoopFuture<View> {
        let query = try req.query.decode(Room.Querry.self)
        let user = req.auth.get(User.self)
        return RoomStore()
            .getAllRooms(query, req: req)
            .flatMap { page in
            return req.view.render(
                "index",
                Room.getContext(baseUrl: req.baseUrl, page: page, query: query, user: user)
            )
        }
    }
    
    func create(req: Request) throws -> EventLoopFuture<Response> {
        try RoomStore().create(req: req).map({ room in
            req.redirect(to: "/myRooms")
        })
    }
    
    func edit(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            var user: User
            var room: Room?
            var images: [String]
        }
        let user  = try req.auth.require(User.self)
        return try RoomStore().edit(req: req).flatMap { room in
            let images = room.getImages(baseUrl: req.baseUrl)
            return req.view.render("editRoom", Context(user: user, room: room, images: images))
        }  
    }
    
    func update(req: Request) throws -> EventLoopFuture<Response> {
        let input = try req.content.decode(Room.Update.self)
        return try RoomStore().update(req: req, input: input).map({ room in
            req.redirect(to: "/myRooms")
        })
    }
    
    func showMyRooms(req: Request) throws -> EventLoopFuture<View> {
        let query = try req.query.decode(Room.Querry.self)
        let user = req.auth.get(User.self)
        return RoomStore().getMyRooms(req: req, user: user!).flatMap { rooms in
            struct Context: Encodable {
                var items: [Room.Output]
                var user: User?
                var url = "myrooms"
            }
            return req.view.render("myroom", Context(items: rooms, user: user))
        }
    }

    func new(req: Request) throws -> EventLoopFuture<View> {
        let user = try req.auth.require(User.self)
        req.logger.log(level: .critical, "user inside new is \(user)", metadata: nil)
        struct Context: Encodable {
            var user: User
            var room: Room?
        }
        return req.view.render("addRoom", Context(user: user))
    }
    
    func showProfile(req: Request) -> EventLoopFuture<View> {
        let user = req.auth.get(User.self)
        struct Context: Encodable {
            var user: User?
            var url = "profile"
        }
        return  req.view.render("personalInformation", Context(user: user))
    }
    
    func destroy(req: Request) throws -> EventLoopFuture<Response> {
        return try RoomStore().delete(req: req).map { deleted in
            req.redirect(to: "/myrooms")
        }
    }
}





class UrlMaker {
    var req: Request
    
    init(req: Request) {
        self.req = req
    }
    
    func url() -> String {
        return req.url.path
    }
}
