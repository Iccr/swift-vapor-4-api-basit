//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//

import Fluent


extension City {
    
    
    struct CreateCityMigration: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.City)
                .field("id", .int, .identifier(auto: true))
                .field("name", .string, .required)
                .field("image_url", .string, .required)
                .field("description", .string, .required)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.City).delete()
        }
    }
    
    struct AddLatLongToCity: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.City)
                .field("lat", .double)
                .field("long", .double)
                .update()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.City)
                .deleteField("lat")
                .deleteField("long")
                .update()
        }
    }
    
    struct AddNepaliNameToCity: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.City)
                .field("nepali_name", .double)
                .update()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Schema.City)
                .deleteField("nepali_name")
                .update()
        }
    }

}
