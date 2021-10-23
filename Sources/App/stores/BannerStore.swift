//
//  File.swift
//  
//
//  Created by ccr on 23/10/2021.
//

import Foundation
import Vapor

class BannerStore {
    func getAllBanner(req: Request) throws -> EventLoopFuture<[Banner.Output]> {
        return Banner.query(on: req.db).all().mapEach { Banner -> Banner.Output in
            return Banner.responseFrom(baseUrl: req.baseUrl)
        }
    }
}

class CityStore {
    func getAllCity(req: Request) throws -> EventLoopFuture<[City.Output]> {
        
        return City.query(on: req.db).with(\.$rooms).all().mapEach { City -> City.Output in
            
            return City
                .responseFrom(baseUrl: req.baseUrl)
        }
    }
}
