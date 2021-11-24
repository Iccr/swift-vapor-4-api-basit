//
//  File.swift
//  
//
//  Created by ccr on 24/11/2021.
//


import Foundation
import Fluent
import Vapor

final class Report : Model, Content {
    static let schema: String = "reports"
    

    @ID(custom: "id")
    var id: Int?

//    {id, reason, remarks}
    
    @Field(key: "propertyId")
    var propertyId : Int
    
    @Field(key: "reason")
    var reason : String

    @Field(key: "remarks")
    var remarks : String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {
        
    }

    init(id: Int? = nil, reason: String, remarks: String) {
        self.id = id
        self.reason = reason
        self.remarks = remarks
    }
}

