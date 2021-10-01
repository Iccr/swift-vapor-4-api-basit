//
//  File.swift
//  
//
//  Created by ccr on 01/10/2021.
//

import Foundation
import Vapor
import Fluent

final class Room: Codable, Model, Content {
    init() {
        
    }
    

    
    static let schema: String = "rooms"
    
    @ID(custom: "id")
    var id : Int?
    
    @Field(key: "price")
    var price : Double?
    
    @Field(key: "images")
    var images : [String]?
    
    @Field(key: "userId")
    var userId : Int?
    
    @Field(key: "type")
    var type : String?
    
    @Field(key: "noOfRooms")
    var noOfRooms : Int?
    
    @Field(key: "kitchen")
    var kitchen : String?
    
    @Field(key: "floor")
    var floor : String?
    
    @Field(key: "lat")
    var lat : Double?
    
    @Field(key: "long")
    var long : Double?
    
    @Field(key: "address")
    var address : String?
    
    @Field(key: "district")
    var district : String?
    
    @Field(key: "state")
    var state : String?
    
    @Field(key: "localGov")
    var localGov : String?
    
    @Field(key: "parking")
    var parking : String?
    
    @Field(key: "water")
    var water : String?
    
    @Field(key: "internet")
    var internet : String?
    
    @Field(key: "phone")
    var phone : String?
    
    @Field(key: "description")
    var description : String?
    
    @Field(key: "occupied")
    var occupied : Bool?
    
    
    @Field(key: "preference")
    var preference : String?
    
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    init(id: Int? = nil, price: Double, images: [String], userId: Int, type: String, noOfRooms: Int, kitchen: String,
         floor: String, lat: Double, long: Double, address: String, district: String, state: String, localGov: String,
         parking: String,  water: String, internet: String, phone: String, description: String,
         occupied: Bool, preference: String, createdAt: Date? = nil, updatedAt: Date? = nil ) {
        self.id = id
        self.price = price
        self.images = images
        self.userId = userId
        self.type = type
        self.noOfRooms = noOfRooms
        self.kitchen = kitchen
        self.floor = floor
        self.water = water
        self.internet = internet
        self.phone = phone
        self.description = description
        self.occupied = occupied
        self.preference = preference
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
    
    
    
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case price = "price"
            case images = "images"
            case userId = "userId"
            case type = "type"
            case noOfRooms = "noOfRooms"
            case kitchen = "kitchen"
            case floor = "floor"
            case lat = "lat"
            case long = "long"
            case address = "address"
            case district = "district"
            case state = "state"
            case localGov = "localGov"
            case parking = "parking"
            case water = "water"
            case internet = "internet"
            case phone = "phone"
            case description = "description"
            case occupied = "occupied"
            case preference = "preference"
    
            case createdAt = "createdAt"
            case updatedAt = "updatedAt"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            price = try values.decodeIfPresent(Double.self, forKey: .price)
            images = try values.decodeIfPresent(Array<String>.self, forKey: .images)
            userId = try values.decodeIfPresent(Int.self, forKey: .userId)
            type = try values.decodeIfPresent(String.self, forKey: .type)
            noOfRooms = try values.decodeIfPresent(Int.self, forKey: .noOfRooms)
            kitchen = try values.decodeIfPresent(String.self, forKey: .kitchen)
            floor = try values.decodeIfPresent(String.self, forKey: .floor)
            lat = try values.decodeIfPresent(Double.self, forKey: .lat)
            long = try values.decodeIfPresent(Double.self, forKey: .long)
            address = try values.decodeIfPresent(String.self, forKey: .address)
            district = try values.decodeIfPresent(String.self, forKey: .district)
            state = try values.decodeIfPresent(String.self, forKey: .state)
            localGov = try values.decodeIfPresent(String.self, forKey: .localGov)
            parking = try values.decodeIfPresent(String.self, forKey: .parking)
            water = try values.decodeIfPresent(String.self, forKey: .water)
            internet = try values.decodeIfPresent(String.self, forKey: .internet)
            phone = try values.decodeIfPresent(String.self, forKey: .phone)
            description = try values.decodeIfPresent(String.self, forKey: .description)
            occupied = try values.decodeIfPresent(Bool.self, forKey: .occupied)
            preference = try values.decodeIfPresent(String.self, forKey: .preference)
            createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
            updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
        }
    
    
}
