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
        rooms.get(use: index)
        let secureRooms = rooms.grouped(User.redirectMiddleware(path: "/?loginRequired=true"))
        
        secureRooms.post("destroy", use: destroy)
        
        let secureRoutes = routes.grouped(User.redirectMiddleware(path: "/?loginRequired=true"))
        secureRoutes.get("myrooms", use: showMyRooms)
        
        secureRoutes.get("profile", use: showProfile)
        
    }
    
    func index(req: Request) throws -> EventLoopFuture<View> {
        let query = try req.query.decode(Room.Querry.self)
        let user = req.auth.get(User.self)
        return RoomStore().getAllRooms(query, req: req).flatMap { page in
            return req.view.render(
                "index",
                Room.getContext(baseUrl: req.baseUrl, page: page, query: query, user: user)
            )
        }
    }
    
    func showMyRooms(req: Request) throws -> EventLoopFuture<View> {
        let query = try req.query.decode(Room.Querry.self)
//        let user = req.auth.get(User.self)
        return RoomStore().getAllRooms(query, req: req).flatMap { page in
            struct Context: Encodable {
                var items: [Room.Output]
                var url = "myrooms"
            }
            return req.view.render("myroom", Context(items: page.items))
            
        }
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

