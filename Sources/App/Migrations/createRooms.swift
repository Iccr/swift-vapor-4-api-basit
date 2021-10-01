//
//  File.swift
//  
//
//  Created by ccr on 01/10/2021.
//

import Foundation
import Fluent

struct CreateRoom: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("rooms")
            .id()
            .field("price", .double, .required)
            .field("images", .array(of: .string), .required)
            .field("userId", .int, .foreignKey("users", .key("id"), onDelete: .cascade, onUpdate: .cascade))
            .field("type", .string, .required)
            .field("noOfRooms", Int, .required)
            .field("kitchen", .string, .required)
            .field("floor", .string, .required)
            .field("lat", .double, .required)
            .field("long", .double, .required)
            .field("address", .string, .required)
            .field("district", .string, .required)
            .field("state", .string, .required)
            .field("localGov", .string, .required)
            .field("parking", .string, .required)
            .field("water", .string, .required)
            .field("internet", .string, .required)
            .field("phone", .string, .required)
            .field("description", .string, .required)
            .field("occupied", .bool, .sql(false))
            .field("preference", .string, .required)
            .field("createdAt", .datetime, .required)
            .field("updatedAt", .datetime, .required)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("rooms").delete()
    }
    
    
}
//
//"rooms": [
//      {
//        "id": 315,
//        "price": 20000,
//        "images": "40644zpksemscac,40644zpksemscnp,40644zpksemscqa,40644zpksemscs3",
//        "userId": 123,
//        "type": "Flat",
//        "noOfRooms": 4,
//        "kitchen": "Available",
//        "floor": "Ground Floor",
//        "lat": 27.6558263,
//        "long": 85.31329270000003,
//        "address": "14, Nakhodol, Lalitpur, Lalitpur",
//        "district": "Lalitpur",
//        "state": null,
//        "localGov": null,
//        "parking": "Car",
//        "water": "Careful Handling",
//        "internet": "Not Available",
//        "phone": "9841564867",
//        "description": "4 Rooms including one Kitchen/dining. Well-carpeted rooms.",
//        "occupied": false,
//        "preference": "Any",
//        "expiresAt": "2021-09-16T12:46:28.000Z",
//        "createdAt": "2021-08-16T12:46:28.000Z",
//        "updatedAt": "2021-08-16T12:46:28.000Z"
//      }
