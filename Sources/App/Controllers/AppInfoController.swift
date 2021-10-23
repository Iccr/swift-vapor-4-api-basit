//
//  File.swift
//  
//
//  Created by ccr on 23/10/2021.
//

import Foundation
import Vapor

class AppInfoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("appinfo")
        route.get(use: index)
    }
    
    func index(req: Request) throws -> EventLoopFuture<CommonResponse<AppInfo>> {
        return try AppInfoStore().getAppInfo(req: req).map(CommonResponse.init)
    }
}
