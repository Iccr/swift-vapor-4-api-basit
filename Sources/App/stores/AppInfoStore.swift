//
//  File.swift
//  
//
//  Created by ccr on 23/10/2021.
//

import Foundation
import Vapor

class AppInfoStore {
    func getAppInfo(req: Request) throws -> EventLoopFuture<AppInfo> {
        let banners = try BannerStore().getAllBanner(req: req)
        let cities = try CityStore().getAllCity(req: req)
        return banners.and(cities).map(AppInfo.init)
        
    }
}
