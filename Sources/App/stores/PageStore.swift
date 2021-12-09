//
//  File.swift
//  
//
//  Created by ccr on 09/12/2021.
//

import Vapor

class PagesStore {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("static")
//        route.get("privacy", use: privacy)
//        route.get("terms", use: terms)
//        route.get("faq", use: faq)
//        route.get("about", use: about)
    }
    
    
    func privacy(req: Request) throws -> EventLoopFuture<View> {
        
        return req.view.render("static/privacyPolicy")
    }
    
    func terms(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("static/terms")
    }
    
    func faq(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("static/faq")
    }
    
    func about(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("static/about")
    }
}



