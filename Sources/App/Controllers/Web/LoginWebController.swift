//
//  File.swift
//  
//
//  Created by ccr on 13/10/2021.
//

import Foundation

import Vapor
import ImperialCore

class LoginWebController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("login")
        route.get(use: signIn)
        
        let logOutRoute = routes.grouped("logout")
        logOutRoute.get( use: signOut)
        
    }
    
    func signIn(req: Request) -> EventLoopFuture<View> {
        return req.view.render("login")
    }
    
    func signOut(req: Request) -> EventLoopFuture<Response> {
        req.auth.logout(User.self)
        return req.eventLoop.makeSucceededFuture(req.redirect(to: "/"))
    }
}
