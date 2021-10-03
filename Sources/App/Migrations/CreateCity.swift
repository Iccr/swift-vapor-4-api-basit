//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//

import Fluent

struct CreateCity: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("cities")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .field("image_url", .string, .required)
            .field("description", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("cities").delete()
    }
}
