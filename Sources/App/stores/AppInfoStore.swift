//
//  File.swift
//  
//
//  Created by ccr on 23/10/2021.
//

import Foundation
import Vapor
import FluentKit

class AppInfoStore {
    func getAppInfo(req: Request) throws -> EventLoopFuture<AppInfo> {
        let banners = try BannerStore().getAllBanner(req: req)
        let cities = try CityStore().getAllCity(req: req).mapEach({$0.responseFrom(baseUrl: req.baseUrl)})
        let appVersion = getAppVersionInfo(db: req.db)
        
        
        return banners.and(cities).and(appVersion).map { (value: ((banner: [Banner.Output], cities: [City.Output]), appversion: AppVersion?)) in
        
            AppInfo(banners: value.0.banner, cities: value.0.cities, info: value.appversion?.output)
        }
        
    }
    
    func getAppVersionInfo(db: Database) -> EventLoopFuture<AppVersion?> {
        return AppVersion.query(on: db).first()
    }
}



