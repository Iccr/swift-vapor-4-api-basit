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
    var vimages : String
    
    
    //    @Field(key: "userId")
    //    var userId : Int?
    
    @Field(key: "type")
    var type : String?
    
    @Field(key: "city_name")
    var cityName : String?
    
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
    var occupied : Bool
    
    @Field(key: "verified")
    var verified : Bool
    
    @Field(key: "preference")
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
         floor: String, lat: Double, long: Double, address: String, district: String, state: String, localGov: String,
         parking: String,  water: String, internet: String, phone: String, description: String,
         occupied: Bool, preference: String, createdAt: Date? = nil, updatedAt: Date? = nil ) {
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
        self.occupied = occupied
        self.preference = preference
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init() { }
}
