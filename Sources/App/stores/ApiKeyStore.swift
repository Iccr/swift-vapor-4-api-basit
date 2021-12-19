//
//  File.swift
//  
//
//  Created by ccr on 19/12/2021.
//

import Foundation
import Vapor
import Fluent



class ApiKeyStore {
    func getAllKeys(req: Request) throws -> EventLoopFuture<[ApiKey]> {
        return ApiKey.query(on: req.db).sort(\.$createdAt, .ascending).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<ApiKey> {
        let apiKey = try req.content.decode(ApiKey.Input.self).key
        return apiKey.create(on: req.db).map {
            apiKey
                
        }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Void> {
        let toDelete = try req.content.decode(ApiKey.IDInput.self)
        return ApiKey.query(on: req.db)
            .filter(\.$id == toDelete.id)
            .delete()
    }
    
    func update(req: Request) throws -> EventLoopFuture<ApiKey> {
        let toUpdate = try req.content.decode(ApiKey.Input.self)
        return try self.find(toUpdate.id, req: req)
            .unwrap(or: Abort(.badRequest))
            .flatMap { apiKey in
                apiKey.apiKey = toUpdate.apiKey.isEmpty ? apiKey.apiKey : toUpdate.apiKey
                return apiKey.update(on: req.db).map {
                    return apiKey
                }
            }
    }
    
    func find(_ id: Int?, req: Request) throws -> EventLoopFuture<ApiKey?> {
        return ApiKey.find(id, on: req.db)
    }
}


