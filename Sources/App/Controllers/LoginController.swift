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
        let input = try req.content.decode(UserContainer.self).user
        let result =  try! SocialSession().verify(token: input?.token ?? "", provider: "google", req: req)
        return result.flatMap { response in
            let user = response.user
            
            let first = User.query(on: req.db)
                .filter(\.$email == response.user.email)
                .first()
            return first.flatMap { oUser -> EventLoopFuture<User> in
                if let user = oUser {
                    user.fcm = user.fcm
                    return user.update(on: req.db).map {
                        return user
                    }
                    
                }
                return user.create(on: req.db).flatMapThrowing {
                    let payload = JwtModel(
                       subject: SubjectClaim(value: "\(user.id!)"),
                       expiration: .init(value: .distantFuture)
                   )
                   let generatedToken = try req.jwt.sign(payload)
//                    print(user.token ?? "")
                   user.token = generatedToken
                   // return response
                   return  user
                }
            }
        }
    }
    
    
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}


