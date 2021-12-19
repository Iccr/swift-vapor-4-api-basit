//
//  File.swift
//  
//
//  Created by ccr on 19/12/2021.
//

import Foundation
import Fluent
import Vapor

final class ApiKey : Model, Content {
    static let schema = Schema.apiKey

    @ID(custom: "id")
    var id: Int?

    @Field(key: "apiKey")
    var apiKey : String?
    

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {
        
    }

    init(id: Int? = nil, apiKey: String) {
        self.id = id
        self.apiKey = apiKey
    }
}

