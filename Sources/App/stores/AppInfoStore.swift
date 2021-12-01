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
        let featured = RoomStore().getFeatured(req: req)
        let appVersion = getAppVersionInfo(db: req.db)
        return featured
            .and(banners)
            .and(cities)
            .and(appVersion)
            .map { (value: (((([Room.Output], [Banner.Output]), [City.Output]), AppVersion?))) in
                let featured = value.0.0.0
                let banners = value.0.0.1
                let cities = value.0.1
                let appversion = value.1
                return AppInfo(
                    banners: banners,
                    cities: cities,
                    info: appversion?.output,
                    featured: featured)
            }
    }
    
    func getAppVersionInfo(db: Database) -> EventLoopFuture<AppVersion?> {
        return AppVersion.query(on: db).first()
    }
}



