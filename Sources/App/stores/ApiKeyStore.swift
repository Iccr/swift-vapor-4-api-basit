//
//  File.swift
//  
//
//  Created by ccr on 19/12/2021.
//

import Foundation
import Vapor
import Fluent



class CityStore {
    func getAllCity(req: Request) throws -> EventLoopFuture<[ApiKey]> {
        return City.query(on: req.db).with(\.$rooms).sort(\.$createdAt, .ascending).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<ApiKey> {
        let city = try req.content.decode(City.Input.self).city
        return city.create(on: req.db).map {
            city
                
        }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Void> {
        let toDelete = try req.content.decode(ApiKey.IDInput.self)
        return City.query(on: req.db)
            .filter(\.$id == toDelete.id)
            .delete()
    }
    
    func update(req: Request) throws -> EventLoopFuture<City> {
        let toUpdate = try req.content.decode(ApiKey.Input.self)
        return try self.find(toUpdate.id, req: req)
            .unwrap(or: Abort(.badRequest))
            .flatMap { city in
                city.name = toUpdate.name
                city.imageUrl = toUpdate.image ?? city.imageUrl
                city.description = toUpdate.description ?? city.description
                city.lat = toUpdate.lat ?? city.lat
                city.long = toUpdate.long ?? city.long
                city.nepaliName = toUpdate.nepaliName
                return city.update(on: req.db).map {
                    return city
                }
            }
    }
    
    func find(_ id: Int?, req: Request) throws -> EventLoopFuture<ApiKey?> {
        return ApiKey.find(id, on: req.db)
    }
}


