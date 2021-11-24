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
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {
        
    }

    init(id: Int? = nil, propertyId: Int,  reason: String, remarks: String) {
        self.id = id
        self.propertyId = propertyId
        self.reason = reason
        self.remarks = remarks
    }
}

extension Report {
    struct Input: Content{
        var id: Int
        var reason: String
        var remarks: String
    }
    
    struct Output: Content {
        var message: String
    }
}


extension Report.Input {
    var report: Report {
        .init(id: nil, propertyId: self.id, reason: self.reason, remarks: self.remarks)
    }
}
