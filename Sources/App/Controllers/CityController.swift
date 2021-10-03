//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//



import Foundation
import Fluent
import Vapor

struct CityController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
    }
    
    func index(req: Request) throws -> EventLoopFuture<[City.Output]> {
        return City.query(on: req.db).all().mapEach { city -> City.Output in
            return city.response(baseUrl: req.baseUrl)
        }
    }
    
   
}


extension Request {
    var baseUrl: String {
        let configuration = application.http.server.configuration
        let scheme = configuration.tlsConfiguration == nil ? "http" : "https"
        let host = configuration.hostname
        let port = configuration.port
        return "\(scheme)://\(host):\(port)"
    }
}
