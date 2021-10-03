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
    
    func index(req: Request) throws -> EventLoopFuture<[City]> {
        return City.query(on: req.db).all()
    }
    
   
}
