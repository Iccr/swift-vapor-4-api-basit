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
        
    }
    
    func index(req: Request) throws -> EventLoopFuture<CommonResponse<[Banner.Output]>> {
       return  try BannerStore().getAllBanner(req: req).map (CommonResponse.init)
        
    }
    
   
}
