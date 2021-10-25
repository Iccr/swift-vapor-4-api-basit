//
//  File.swift
//  
//
//  Created by ccr on 25/10/2021.
//

import Foundation
import Vapor

struct EnsureAdminUserMiddleware: Middleware {

   func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {

    guard let user = request.auth.get(User.self), user.role == .admin else {
        return request.eventLoop.future(error:  Abort.redirect(to: "/"))
    }

    return next.respond(to: request)
    }

}

class AdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("admin")
        let secure = route.grouped(EnsureAdminUserMiddleware())
        route.get("login", use: new)
        route.post("login", use: login)
        
        secure.get("dashboard", use: dashboard)
        secure.get("rentals", use: rentals)
        secure.get("city", use: city)
       
        
        

    }
    
    func new(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("admin/pages/login")
    }
    
    func login(req: Request) throws -> EventLoopFuture<View> {
        print(req)
        return req.view.render("admin/pages/login")
    }
    
    func dashboard(req: Request) throws -> EventLoopFuture<View> {
        let user = try req.auth.require(User.self)
        if user.hasRole(.admin) {
            return req.view.render("admin/pages/dashboard")
        }
        
        throw Abort.redirect(to: "/")
    }
    
    func rentals(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("admin/pages/rentals")
        
    }
    
    func city(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("admin/pages/city")
        
    }
}
