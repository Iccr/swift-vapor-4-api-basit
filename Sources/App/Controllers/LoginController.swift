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
    
    
//    app.post("galaxies") { req -> EventLoopFuture<Galaxy> in
//        let galaxy = try req.content.decode(Galaxy.self)
//        return galaxy.create(on: req.db)
//            .map { galaxy }
//    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(UserContainer.self).user
        let result =  try! SocialSession().verify(token: user?.token ?? "", provider: "google", req: req)
        return result.flatMap { response in
            let user = response.user
            
            let first = User.query(on: req.db)
                .filter(\.$email == response.user.email)
                .first()
            return first.flatMap { oUser -> EventLoopFuture<User> in
                if let user = oUser {
                    return req.eventLoop.future(user)
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
//    func create(req: Request) throws -> EventLoopFuture<User> {
//        // decode user
//        let user = try req.content.decode(UserContainer.self).user
//        // check if user exist
//        return User.find(user?.id, on: req.db).flatMap { oUser -> EventLoopFuture<User> in
//            // if exist return that user
//            if let user = oUser {
//                return req.eventLoop.future(user)
//            }
//            // if not veriry with google
//            return SocialSession().verify(token: user?.token ?? "", provider: "google", req: req).flatMapThrowing  { response -> User in
//                // if not verified with google
//
//                if response.error != nil {
//                    // if not verified throw unauthorized
//                    throw Abort(.unauthorized)
//                }
//
//                // if verified
//                // create user
//                return response.user
//                // create token
//
//            }.flatMap { user ->   EventLoopFuture<User> in
//                return user.create(on: req.db).flatMapThrowing({
//                    let payload = JwtModel(
//                        subject: SubjectClaim(value: "\(user.id!)"),
//                        expiration: .init(value: .distantFuture)
//                    )
//                    let generatedToken = try req.jwt.sign(payload)
////                    print(user.token ?? "")
//                    user.token = generatedToken
//                    // return response
//                    return  user
//                })
//            }
//        }
//    }
    
    
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}


