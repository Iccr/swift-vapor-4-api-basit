//
//  File.swift
//  
//
//  Created by ccr on 01/10/2021.
//

import Foundation
import Vapor
import Fluent



final class Room: Model, Content {
    static let schema: String = "rooms"
    
    @Parent(key: "city_id")
    var city: City
    
    @Parent(key: "userId")
    var user: User
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "price")
    var price : Double?
    
    @Field(key: "images")
    var vimages : String?
    
    
    //    @Field(key: "userId")
    //    var userId : Int?
    
    @Field(key: "type")
    var type : String?
    
    @OptionalField(key: "city_name")
    var cityName : String?
    
    @OptionalField(key: "noOfRooms")
    var noOfRooms : Int?
    
    @OptionalField(key: "kitchen")
    var kitchen : String?
    
    @OptionalField(key: "floor")
    var floor : String?
    
    @OptionalField(key: "lat")
    var lat : Double?
    
    @OptionalField(key: "long")
    var long : Double?
    
    @OptionalField(key: "address")
    var address : String?
    
    @OptionalField(key: "district")
    var district : String?
    
    @OptionalField(key: "state")
    var state : String?
    
    @OptionalField(key: "localGov")
    var localGov : String?
    
    @OptionalField(key: "parking")
    var parking : String?
    
    @OptionalField(key: "water")
    var water : String?
    
    @OptionalField(key: "internet")
    var internet : String?
    
    @OptionalField(key: "phone")
    var phone : String?
    
    @OptionalField(key: "featured")
    var featured : Bool?
    
    @OptionalField(key: "description")
    var description : String?
    
    @Field(key: "occupied")
    var occupied : Bool
    
    @Field(key: "verified")
    var verified : Bool
    
    @OptionalField(key: "preference")
    var preference : String?
    
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    init(id: Int? = nil, price: Double, vimages: [String],
         city: City,
         user: User,
         cityName: String?,
         type: String, noOfRooms: Int, kitchen: String,
         floor: String, lat: Double?, long: Double?, address: String, district: String?, state: String?, localGov: String?,
         parking: String,  water: String, internet: String, phone: String, description: String?,
         occupied: Bool?, preference: String, createdAt: Date? = nil, updatedAt: Date? = nil, featured: Bool? = nil ) {
        self.id = id
        
        self.price = price
        self.vimages = vimages.joined(separator: ",")
        self.cityName = cityName
        //        self.vimages = vimages ?? ["sadfasdf"]
        //        self.userId = userId
        self.$user.value = user
        self.$city.value = city
        //        self.city = city
        self.type = type
        self.noOfRooms = noOfRooms
        self.kitchen = kitchen
        self.floor = floor
        self.water = water
        self.internet = internet
        self.phone = phone
        self.description = description
        self.occupied = occupied ?? false
        self.preference = preference
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.featured = featured
        
    }
    
    init() { }
}
