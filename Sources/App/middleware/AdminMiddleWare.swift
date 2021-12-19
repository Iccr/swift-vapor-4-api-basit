//
//  File.swift
//  
//
//  Created by ccr on 19/12/2021.
//

import Foundation
import Vapor
import Fluent


struct EnsureAdminUserMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        guard let user = request.auth.get(User.self), user.role == .admin else {
            return request.eventLoop.future(error:  Abort.redirect(to: "/"))
        }
        
        return next.respond(to: request)
    }
    
}
