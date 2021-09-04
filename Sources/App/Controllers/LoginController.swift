//
//  File.swift
//  
//
//  Created by ccr on 03/09/2021.
//

import Foundation


import Fluent
import Vapor
import JWT

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

    
        let fetch = User.find(1, on: req.db)
       
        return fetch.flatMapThrowing { user ->  User in
                if let user = user {
                    print(user)
                   return user
                }
                
                let payload = JwtModel(
                        subject: "vapor",
                    expiration: .init(value: .distantFuture),
                        isAdmin: true
                    )
                let generatedToken = try req.jwt.sign(payload)
                print(model.user?.token ?? "")
                model.user?.authToken = generatedToken
                return model.user!
        }
        
        
//        return model.save(on: req.db).map { todo }
//        return .ok
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
