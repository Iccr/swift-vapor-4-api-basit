//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation
import Vapor


extension Room {
    struct Querry: Content, Codable {
        var city: String?
        var id: Int?
        var lowerPrice : Double?
        var upperPrice : Double?
        var type : [String] = []
        var noOfRooms : Int?
        var kitchen : String?
        var floor : String?
        var lat : Double?
        var long : Double?
        var address : String?
        var district : String?
        var state : String?
        var localGov : String?
        var parking : [String] = []
        var water : String?
        var internet : String?
        var phone : String?
        var description : String?
        var occupied : Bool?
        var preference : String?
        var price: String?
        var sortBy: String?
        var page: Int? = 1
        var per: Int? = 10
        var alert: String?
        var alertLevel: Int?
        var userId: Int?
        var loginRequired: Bool = false
        
        func getQeury() -> [URLQueryItem] {
            let query = self
            var _query: [URLQueryItem] = []
            if let cityname = query.city {
                _query.append(URLQueryItem(name: "city", value: cityname))
            }
            
            if let lowerPrice = query.lowerPrice {
                _query.append(URLQueryItem(name: "lowerPrice", value: lowerPrice.toString))
            }
            
            if let upperPrice = query.upperPrice {
                _query.append(URLQueryItem(name: "upperPrice", value: upperPrice.toString))
            }
            
            query.type.forEach({
                _query.append(URLQueryItem(name: "type", value: $0))
            })
            
            if let noOfRooms = query.noOfRooms {
                _query.append(URLQueryItem(name: "noOfRooms", value: noOfRooms.toString))
            }
            
            if let kitchen = query.kitchen {
                _query.append(URLQueryItem(name: "kitchen", value: kitchen))
            }
            
            if let floor = query.floor {
                _query.append(URLQueryItem(name: "floor", value: floor))
            }
            
            if let lat = query.lat {
                _query.append(URLQueryItem(name: "lat", value: lat.toString))
            }
            
            if let long = query.long {
                _query.append(URLQueryItem(name: "long", value: long.toString))
            }
            
            if let address = query.address {
                _query.append(URLQueryItem(name: "address", value: address))
            }
            
            if let district = query.district {
                _query.append(URLQueryItem(name: "district", value: district))
            }
            
            if let state = query.state {
                _query.append(URLQueryItem(name: "state", value: state))
            }
            
            if let localGov = query.localGov {
                _query.append(URLQueryItem(name: "localGov", value: localGov))
            }
            
            query.parking.forEach({
                _query.append(URLQueryItem(name: "parking", value: $0))
            })
            
            if let water = query.water {
                _query.append(URLQueryItem(name: "water", value: water))
            }
            
            if let internet = query.internet {
                _query.append(URLQueryItem(name: "internet", value: internet))
            }
            
            if let phone = query.phone {
                _query.append(URLQueryItem(name: "phone", value: phone))
            }
            
            if let description = query.description {
                _query.append(URLQueryItem(name: "description", value: description))
            }
            
            if let occupied = query.occupied {
                _query.append(URLQueryItem(name: "occupied", value: occupied.toString))
            }
            
            if let preference = query.preference {
                _query.append(URLQueryItem(name: "preference", value: preference))
            }
            
            if let price = query.price {
                _query.append(URLQueryItem(name: "price", value: price))
            }
            
            if let page = query.page {
                _query.append(URLQueryItem(name: "page", value: page.toString))
            }
            
            
            
            _query.append(URLQueryItem(name: "per", value: query.per?.toString ?? 10.toString))
            
            return _query
        }
    }
}

