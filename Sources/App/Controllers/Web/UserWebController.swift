//
//  File.swift
//  
//
//  Created by ccr on 22/10/2021.
//

import Foundation
import Vapor

class UserWebController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        let secureUser =  users.grouped(User.redirectMiddleware(path: "/?loginRequired=true"))
        secureUser.post(":id", use: update)
        let secureRoutes =  users.grouped(User.redirectMiddleware(path: "/?loginRequired=true"))
        secureRoutes.get("profile", use: showProfile)
        
    }
    
    
    func update(req: Request) throws -> EventLoopFuture<Response> {
        let toUpdate = try? req.content.decode(User.Profile.self)
        return User.find(toUpdate?.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.name = toUpdate?.name
               return user.update(on: req.db).map {
                    req.redirect(to: "/profile")
                }
            }
        
    }
    
    func showProfile(req: Request) -> EventLoopFuture<View> {
        let user = req.auth.get(User.self)
        return  req.view.render("personalInformation", ["user": user])
    }
    
   
}


//func update(req: Request) throws -> EventLoopFuture<Response> {
//    let toUpdate = try req.content.decode(Category.self)
//    let id = req.parameters.get("id", as: Int.self)
//
//    return category(id, on: req).flatMap { category in
//        if let category = category {
//            category.name = toUpdate.name
//            category.isMain = toUpdate.isMain
//            return category.update(on: req.db).map({
//                req.redirect(to: "/categories")
//            })
//        }else {
//            return req.eventLoop.makeSucceededFuture(req.redirect(to: "/categories"))
//        }
//
//    }
//
//}
