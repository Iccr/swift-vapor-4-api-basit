//
//  File.swift
//  
//
//  Created by ccr on 24/11/2021.
//

import Foundation



import Fluent


extension City {
    
    
    struct CreateCityMigration: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.Report)
                .field("id", .int, .identifier(auto: true))
                .field("reason", .string, .required)
                .field("remarks", .string, .required)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.Report).delete()
        }
    }
}
