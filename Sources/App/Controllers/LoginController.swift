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
    
    //    func create(req: Request) throws -> EventLoopFuture<User> {
    //        // decode user
    //        let user = try req.content.decode(UserContainer.self).user
    //        // check if user exist
    //        return  User.find(user?.id, on: req.db).map { oUser in
    //            // if exist return that user
    //            if let user = oUser {
    //                return user
    //            }
    //            // if not veriry with google
    //            return  SocialSession()
    //                .verify(token: user?.token ?? "", provider: "google", req: req)
    //                .map { response in
    //                    // if not verified with google
    //                    if let error = response.error {
    //                        // if not verified throw unauthorized
    //                        throw Abort(.unauthorized)
    //                    }
    //                    // if verified
    //                    // create user
    //                    let user = user?.create(on: req.db)
    //                    // create token
    //                    let payload = JwtModel(
    //                        subject: user.id!,
    //                        expiration: .init(value: .distantFuture)
    //                    )
    //                    let generatedToken = try req.jwt.sign(payload)
    //                    print(user?.token ?? "")
    //                    user?.authToken = generatedToken
    //                    // return response
    //                    return  user!
    //                }
    //        }
    //    }
    
 
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        // decode user
        let user = try req.content.decode(UserContainer.self).user
        // check if user exist
        return  User.find(user?.id, on: req.db)
            .flatMapThrowing { oUser throws -> User in
                if let user = oUser {
                    return user
                }
                let result =  try SocialSession()
                    .verify(token: user?.token ?? "", provider: "google", req: req)
                
                let user = result.user
                let _ = user.create(on: req.db)
                
                
                let payload = JwtModel(
                    subject: SubjectClaim(value: "\(user.id!))"),
                    expiration: .init(value: .distantFuture)
                )
                let generatedToken = try req.jwt.sign(payload)
                print(user.token ?? "")
                user.authToken = generatedToken
                // return response
                return  user
            }
        
        
        
        
        //            User.find(user?.id, on: req.db).map { oUser in
        //            // if exist return that user
        //            if let user = oUser {
        //                return user
        //            }
        //            // if not veriry with google
        //            return  SocialSession()
        //                .verify(token: user?.token ?? "", provider: "google", req: req)
        //                .map { response in
        //                    // if not verified with google
        //                    if let error = response.error {
        //                        // if not verified throw unauthorized
        //                        throw Abort(.unauthorized)
        //                    }
        //                    // if verified
        //                    // create user
        //                    let user = user?.create(on: req.db)
        //                    // create token
//                            let payload = JwtModel(
//                                subject: user.id!,
//                                expiration: .init(value: .distantFuture)
//                            )
//                            let generatedToken = try req.jwt.sign(payload)
//                            print(user?.token ?? "")
//                            user?.authToken = generatedToken
//                            // return response
//                            return  user!
        //                }
        //        }
    }
    
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}


