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
        let secure = route.grouped(EnsureAdminUserMiddleware())
        route.get("login", use: new)
        route.post("login", use: login)
        
        secure.get("dashboard", use: dashboard)
        secure.get("rentals", use: rentals)
        secure.get("city", use: city)
        secure.post("city", use: cityCreate)
        secure.get("city", "new", use: cityNew)
        secure.post("city", "delete", use: cityDelete)
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
        try CityStore().getAllCity(req: req).flatMap { cities in
            struct Context: Encodable {
                var items: [City]
            }
            return req.view.render("admin/pages/city", Context(items: cities))
        }
    }
    
    func cityNew(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("admin/pages/cityForm")
    }
    
    func cityCreate(req: Request) throws -> EventLoopFuture<Response> {
        try CityStore().create(req: req).map { city in
            return req.redirect(to: "/admin/city")
        }
    }
    
  
    func cityDelete(req: Request) throws -> EventLoopFuture<Response> {
        try CityStore().delete(req: req).map { city in
            return req.redirect(to: "/admin/city")
        }
    }
}

struct EnsureAdminUserMiddleware: Middleware {

   func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {

    guard let user = request.auth.get(User.self), user.role == .admin else {
        return request.eventLoop.future(error:  Abort.redirect(to: "/"))
    }

    return next.respond(to: request)
    }

}
