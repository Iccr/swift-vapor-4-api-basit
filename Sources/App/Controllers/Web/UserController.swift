//
//  File.swift
//  
//
//  Created by ccr on 22/10/2021.
//

import Foundation
import Vapor

class UserController {
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
