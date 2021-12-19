//
//  File.swift
//  
//
//  Created by ccr on 19/12/2021.
//

import Foundation
import Vapor
import Fluent

struct EnsureApiDomainMiddleware: Middleware {
    
//    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
//        print(request.headers["apiKey"])
//        if let headersKey = request.headers["apiKey"].first {}
//        print(request)
////        guard let user = request.auth.get(User.self), user.role == .admin else {
////            return request.eventLoop.future(error:  Abort.redirect(to: "/"))
////        }
//
//        return next.respond(to: request)
//    }
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let key = request.headers["apiKey"].first else {
            return next.respond(to: request).flatMapThrowing { response in
                let res = Response(status: .unauthorized, headers:  request.headers)
                res.body = try .init(data: JSONEncoder().encode(["error": "unauthorized access"] ))
                res.headers.add(name: .contentType, value: "application/json")
                return res
                 
             }
        }
        return ApiKey.query(on: request.db).filter(\.$apiKey == key).first().flatMap { _apiKey in
            if let validKey = _apiKey, key == validKey.apiKey {
                return next.respond(to: request)
            }else {
               return next.respond(to: request).flatMapThrowing { response in
                   let res = Response(status: .unauthorized, headers:  request.headers)
                   res.body = try .init(data: JSONEncoder().encode(["error": "unauthorized access"] ))
                   res.headers.add(name: .contentType, value: "application/json")
                   return res
                    
                }
            }
        }
        
       
        
    }
    
}
