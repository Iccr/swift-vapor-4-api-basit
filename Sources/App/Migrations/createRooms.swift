//
//  File.swift
//  
//
//  Created by ccr on 01/10/2021.
//

import Foundation
import Fluent



extension Room {
    struct CreateRoomMigration: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("rooms")
                .field("id", .int, .identifier(auto: true))
                .field("price", .double)
                .field("vimages", .array(of: .string))
                .field("city_id", .int, .foreignKey("cities", .key("id"), onDelete: .cascade, onUpdate: .cascade))
                .field("user_id", .int, .foreignKey("users", .key("id"), onDelete: .cascade, onUpdate: .cascade))
                .field("type", .string)
                .field("no_of_rooms", .int)
                .field("kitchen", .string)
                .field("floor", .string)
                .field("lat", .double)
                .field("long", .double)
                .field("address", .string)
                .field("district", .string)
                .field("state", .string)
                .field("localGov", .string)
                .field("parking", .string)
                .field("water", .string)
                .field("internet", .string)
                .field("phone", .string)
                .field("description", .string)
                .field("occupied", .bool, .sql(.default(false)))
                .field("preference", .string)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("rooms").delete()
        }
    }
    
    struct AddCityNameToRoomMigration: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("rooms")
                .field("city_name", .string)
                .update()
                
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("rooms")
                .deleteField("city_name")
                .update()
        }
        
        
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
