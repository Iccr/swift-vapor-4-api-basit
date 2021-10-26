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
        return City.query(on: req.db).with(\.$rooms).sort(\.$createdAt, .ascending).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<City> {
        let city = try req.content.decode(City.self)
        return city.create(on: req.db).map {
            city
                
        }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Void> {
        let toDelete = try req.content.decode(City.DeleteInput.self)
        return City.query(on: req.db)
            .filter(\.$id == toDelete.id)
            .delete()
    }
    
    func update(req: Request) throws -> EventLoopFuture<City> {
        let toUpdate = try req.content.decode(City.self)
        return try self.find(toUpdate.id, req: req)
            .unwrap(or: Abort(.badRequest))
            .flatMap { city in
                city.name = toUpdate.name
                city.imageUrl = toUpdate.imageUrl
                city.description = toUpdate.description
                return city.update(on: req.db).map {
                    return city
                }
            }
    }
    
    func find(_ id: Int?, req: Request) throws -> EventLoopFuture<City?> {
        return City.find(id, on: req.db)
    }
}


