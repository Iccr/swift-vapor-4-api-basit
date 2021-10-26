//
//  File.swift
//  
//
//  Created by ccr on 23/10/2021.
//

import Foundation
import Vapor
import Fluent

class BannerStore {
    func getAllBanner(req: Request) throws -> EventLoopFuture<[Banner.Output]> {
        return Banner.query(on: req.db).all().mapEach { Banner -> Banner.Output in
            return Banner.responseFrom(baseUrl: req.baseUrl)
        }
    }
}

class CityStore {
    func getAllCity(req: Request) throws -> EventLoopFuture<[City]> {
        return City.query(on: req.db).with(\.$rooms).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<City> {
        let city = try req.content.decode(City.self)
        return city.create(on: req.db).map {
            city
                
        }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Voidi> {
        let toDelete = try req.content.decode(City.DeleteInput.self)
        return City.query(on: req.db)
            .filter(\.$id == toDelete.id)
            .delete()
    }
}


