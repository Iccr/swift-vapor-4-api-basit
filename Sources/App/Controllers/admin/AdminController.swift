//
//  File.swift
//  
//
//  Created by ccr on 25/10/2021.
//

import Foundation
import Vapor

class AdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("admin")
        
        route.get("login", use: new)
        route.post("login", use: login)
        
        var secure = route.grouped(User.credentialsAuthenticator())
        
        secure = secure.grouped(User.redirectMiddleware(path: "/?loginRequired=true"))
        
        secure.get("dashboard", use: dashboard)


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
}
