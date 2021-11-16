//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation
import Vapor

extension Room {
    func getImages(baseUrl: String) -> [String] {
        let images = self.vimages.components(separatedBy: ",")
        return images.map {
            if let ext = URL.init(string: $0)?.pathExtension, !ext.isEmpty {
                return baseUrl + "/uploads/" + $0
            }else {
                return baseUrl + "/uploads/" + $0 + ".jpg"
            }
        }
    }
}


extension Room {
    struct Entity: Content {
        var images: [File]
        var city_id: Int
    }
}


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
        var page: Int? = 1
        var per: Int? = 10
        var alert: String?
        var alertLevel: Int?
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



extension Room {
    func responseFrom(baseUrl: String)-> Room.Output {
        let r = self
        let images = r.getImages(baseUrl: baseUrl)
        let coverImage: String = images.first ?? ""
        return  Room.Output.init(
            coverImage: coverImage,
            nepaliPrice: (self.price ?? 0).getNumberWithNepaliFormat() ?? "",
            city: $city.value?.responseFrom(baseUrl: baseUrl),
            user: $user.value?.getBasicProfile() ,
            id: r.id,
            price: r.price,
            images: images,
            type: r.type,
            noOfRooms: r.noOfRooms,
            kitchen: r.kitchen,
            floor: r.floor,
            lat: r.lat,
            long: r.long,
            address: r.address,
            district: r.district,
            state: r.state,
            localGov: r.localGov,
            parking: r.parking,
            water: r.water,
            internet: r.internet,
            phone: r.phone,
            description: r.description,
            occupied: r.occupied,
            preference: r.preference,
            createdAt: r.createdAt,
            updatedAt: r.updatedAt,
            features: r.getFeautres(),
            timesAgo: r.createdAt?.timeAgoDisplay() ?? ""
        )
    }
    
    func getFeautres() -> [String] {
        var features: [String] = []
        if let no = noOfRooms,  no != 0 {
            features.append("Rooms: \(no)")
        }
        
        if let floor = floor {
            features.append("Floor: \(floor)")
        }
        
        if let internet = internet {
            features.append("internet: \(internet)")
        }
        
        if let parking = parking {
            features.append("parking: \(parking)")
        }
        
        if let water = water {
            features.append("water: \(water)")
        }
        
        if let kitchen = kitchen {
            features.append("kitchen: \(kitchen)")
        }
        return features
    }
}
