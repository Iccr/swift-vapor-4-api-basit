//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//


import Foundation
import Fluent
import Vapor

struct BannerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("banners")
        route.get(use: index)

    }
    
    func index(req: Request) throws -> EventLoopFuture<CommonResponse<[Banner.Output]>> {
       return  try BannerStore().getAllBanner(req: req).map (CommonResponse.init)
        
    }
    
   
}
