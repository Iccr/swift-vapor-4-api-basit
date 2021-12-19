//
//  File.swift
//  
//
//  Created by ccr on 19/12/2021.
//

import Vapor

class CreateAppVersion: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schema.apiKey)
            .field("id", .int, .identifier(auto: true))
            .field("apiKey", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schema.apiKeyi)
            .delete()
    }
}
