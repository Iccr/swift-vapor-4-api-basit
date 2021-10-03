//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//

import Fluent

struct CreateBanner: Migration {
    let schemaName = "banners"
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(schemaName)
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("subtitle", .string, .required)
            .field("image_url", .string, .required)
            .field("type", .string, .required)
            .field("value", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(schemaName).delete()
    }
}
