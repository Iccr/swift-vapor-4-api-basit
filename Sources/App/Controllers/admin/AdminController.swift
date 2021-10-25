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
        route.get("login", use: login)
    }
    
    func login(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("admin/pages/login")
    }
}
