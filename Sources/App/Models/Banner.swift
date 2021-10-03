//
//  File.swift
//  
//
//  Created by ccr on 03/10/2021.
//

import Foundation
//{
//    "id": 315,
//    "title": "Start Earning",
//    "image": "https://codecanyon.img.customer.envatousercontent.com/files/306929145/preview+image.jpg?auto=compress%2Cformat&fit=crop&crop=top&w=590&h=300&s=f4097017b68f2af4cc562e8b934b8d48",
//    "subtitle": "List a place",
//    "type": "property",
//    "value": "1"
//}
//
import Fluent

final class Banner: Codable, Model {
    static let schema: String = "banners"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "title")
    var title : String?
    
    @Field(key: "image")
    var image : String?
    
    @Field(key: "subtitle")
    var subtitle : String?
    
    @Field(key: "value")
    var value : String?
    
    @Field(key: "type")
    var type : String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    
    init() {
        
    }
    
    init(id: Int? = nil, title: String, image: String, subtitle: String, type: String, value: String) {
        self.id = id
        self.title = title
        self.image = image
        self.subtitle = subtitle
        self.type = type
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case image = "image"
        case subtitle = "subtitle"
        case type = "type"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}
