//
//  File.swift
//  
//
//  Created by ccr on 03/09/2021.
//

import Foundation


import Fluent
import Vapor

struct LoginController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("login")
       
//        todos.post(use: create)
        
        todos.group(":loginID") { todo in
            todo.delete(use: delete)
        }
    }

    func create(req: Request) throws -> EventLoopFuture<User> {
        let model = try req.content.decode(UserContainer.self)
        print(model.user?.token ?? "")
        return req.eventLoop.makeSucceededFuture(model.user!)
//        return model.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
