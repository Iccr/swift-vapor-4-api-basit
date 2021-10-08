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

    @Field(key: "image_url")
    var imageUrl : String?

    @Field(key: "description")
    var description : String?

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

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case imageUrl = "imageUrl"
        case description = "description"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
    
    
     struct Output: Content {
        var id: Int?
        var name : String?
        var imageUrl : String?
        var description : String?
        var createdAt: Date?
        var updatedAt: Date?
        
        
    }

}

extension City {
    func response(baseUrl: String) -> City.Output {
        let city = self
        return .init(id: city.id , name: city.name, imageUrl: baseUrl + (city.imageUrl ?? ""), description: city.description)
    }
}

