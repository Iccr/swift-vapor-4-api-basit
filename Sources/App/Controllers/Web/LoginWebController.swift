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
        routes.get(use: signIn)
    }
    
    func signIn(req: Request) -> EventLoopFuture<View> {
        return req.view.render("login")
    }
}
