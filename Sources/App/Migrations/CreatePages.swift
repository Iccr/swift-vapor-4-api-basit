//
//  File.swift
//  
//
//  Created by ccr on 09/12/2021.
//


import Fluent

extension AppPage {
    
    struct CreatePages: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
                database.schema(Schema.Pages)
                    .field("id", .int, .identifier(auto: true))
                    .field("name", .string)
                    .field("eng", .string)
                    .field("nep", .string)
                    .field("created_at", .datetime)
                    .field("updated_at", .datetime)
                    .create()
            }
            
            func revert(on database: Database) -> EventLoopFuture<Void> {
                database.schema(Schema.Pages).delete()
            }
        
    }

}
