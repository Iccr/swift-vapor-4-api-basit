//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation
import Vapor
import Fluent

extension Room {
    struct Output: Content {
        var coverImage: String
        var nepaliPrice: String
        var city: City.Output?
        var user: User.BasicProfile?
        var id: Int?
        var price : Double?
        var images : [String] = []
        var type : String?
        var noOfRooms : Int?
        var kitchen : String?
        var floor : String?
        var lat : Double?
        var long : Double?
        var address : String?
        var district : String?
        var state : String?
        var localGov : String?
        var parking : String?
        var water : String?
        var internet : String?
        var phone : String?
        var description : String?
        var occupied : Bool?
        var preference : String?
        var createdAt: Date?
        var updatedAt: Date?
        var features: [String]
        var timesAgo: String
        var verified: Bool?
    }
    
    struct Update: Content {
        var id: Int
        var price : Double?
        var type : String?
        var noOfRooms : Int?
        var kitchen : String?
        var floor : String?
        var lat : Double?
        var long : Double?
        var address : String?
        var district : String?
        var state : String?
        var localGov : String?
        var parking : String?
        var water : String?
        var internet : String?
        var phone : String?
        var description : String?
        var occupied : Bool?
        var preference : String?
    }
    
    func get(update: Update) -> Room {
        price = update.price ?? price
        type = update.type ?? type
        noOfRooms = update.noOfRooms ?? noOfRooms
        kitchen = update.kitchen ?? kitchen
        floor = update.floor ?? floor
        lat = update.lat ?? lat
        long = update.long ?? long
        address = update.address ?? address
        district = update.district ?? district
        state = update.state ?? state
        localGov = update.localGov ?? localGov
        parking = update.parking ?? parking
        water = update.water ?? water
        internet = update.internet ?? internet
        phone = update.phone ?? phone
        description = update.description ?? description
        occupied = update.occupied ?? occupied
        preference = update.preference ?? preference
        return self
    }
    
    struct DeleteInput: Content {
        var id: Int
    }
    
    
    struct Input: Content {
        var cityName: String?
        //        var userId: Int?
        var id: Int?
        var price : Double
        var imgs: [String]?
        var type : String
        var noOfRooms : Int
        var kitchen : String
        var floor : String
        var lat : Double?
        var long : Double?
        var address : String
        var district : String?
        var state : String?
        var localGov : String?
        var parking : String
        var water : String
        var internet : String
        var phone : String
        var description : String?
        var occupied : Bool?
        var preference : String
        var createdAt: Date?
        var updatedAt: Date?
        
        func getRoom(city: City, user: User) -> Room {
            return Room.init(id: self.id, price: self.price, vimages: self.imgs ?? [], city: city, user: user, cityName: self.cityName, type: self.type, noOfRooms: self.noOfRooms, kitchen: self.kitchen, floor: self.floor, lat: self.lat, long: self.long, address: self.address, district: self.district, state: self.state, localGov: self.localGov, parking: self.parking, water: self.water, internet: self.internet, phone: self.phone, description: self.description, occupied: self.occupied, preference: self.preference.isEmpty ?  "Anyone" : self.preference, createdAt: self.createdAt, updatedAt: self.updatedAt)
        }
    }
    
}

