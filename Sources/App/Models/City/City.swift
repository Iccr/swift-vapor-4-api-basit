//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//

import Foundation
import Fluent
import Vapor

final class City : Codable, Model, Content {
    static let schema: String = "cities"
    
    @Children(for: \.$city)
    var rooms: [Room]

    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name : String?
    
    @Field(key: "status")
    var status : Bool

    @Field(key: "image_url")
    var imageUrl : String?

    @Field(key: "description")
    var description : String?
    
    @Field(key: "lat")
    var lat : Double?
    
    
    @Field(key: "long")
    var long : Double?
    

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {
        
    }

    init(id: Int? = nil, name: String, image: String, description: String) {
        self.id = id
        self.name = name
        self.imageUrl = image
        self.description = description
    }
}

