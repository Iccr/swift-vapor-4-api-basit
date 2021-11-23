//
//  File.swift
//  File
//
//  Created by ccr on 23/11/2021.
//

import Foundation
import FluentKit

class CreateAppVersion: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schema.AppVersion)
            .field("android", .string)
            .field("ios", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schema.AppVersion)
            .delete()
    }
}
