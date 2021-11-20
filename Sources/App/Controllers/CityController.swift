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
        let route = routes.grouped("cities")
        route.get( use: index)
    }
    
    func index(req: Request) throws -> EventLoopFuture<CommonResponse<[City.Output]>> {
        return try CityStore().getAllCity(req: req).mapEach {$0.responseFrom(baseUrl: req.baseUrl)}.map( CommonResponse.init)
//        return CommonResponse.init(data: cities)
    }
    
   
}


