//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//

import Foundation
import Fluent

final class City : Codable, Model {
    static let schema: String = "cities"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name : String?
    
    @Field(key: "image_url")
    var imageUrl : String?
    
    @Field(key: "description")
    var description : String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {}
    
    init(id: Int? = nil, name: String, image: String, description: String) {
        self.id = id
        self.name = name
        self.imageUrl = image
        self.description = description
    }
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case imageUrl = "imageUrl"
        case description = "description"
//        case propertyCount = "propertyCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        description = try values.decodeIfPresent(String.self, forKey: .description)
//        propertyCount = try values.decodeIfPresent(Int.self, forKey: .propertyCount)
    }

}
