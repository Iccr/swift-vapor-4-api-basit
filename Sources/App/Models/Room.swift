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
    
    @Field(key: "no_of_rooms")
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
    
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case price = "price"
        case vimages = "vimages"
        case userId = "userId"
        case type = "type"
        case noOfRooms = "no_of_rooms"
        case kitchen = "kitchen"
        case floor = "floor"
        case lat = "lat"
        case long = "long"
        case address = "address"
        case district = "district"
        case state = "state"
        case localGov = "local_gov"
        case parking = "parking"
        case water = "water"
        case internet = "internet"
        case phone = "phone"
        case description = "description"
        case occupied = "occupied"
        case preference = "preference"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        vimages = try values.decodeIfPresent(String.self, forKey: .vimages) ?? ""
        //        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
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
    
    
    
    
    
    struct Output: Content, Codable {
        
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
        var vimages : [String] = []
        var type : String
        var noOfRooms : Int
        var kitchen : String
        var floor : String
        var lat : Double
        var long : Double
        var address : String
        var district : String
        var state : String
        var localGov : String
        var parking : String
        var water : String
        var internet : String
        var phone : String
        var description : String
        var occupied : Bool
        var preference : String
        var createdAt: Date?
        var updatedAt: Date?
        
        func getRoom(city: City, user: User) -> Room {
            return .init(id: self.id, price: self.price, vimages: self.vimages, city: city, user: user, cityName: self.cityName, type: self.type, noOfRooms: self.noOfRooms, kitchen: self.kitchen, floor: self.floor, lat: self.lat, long: self.long, address: self.address, district: self.district, state: self.state, localGov: self.localGov, parking: self.parking, water: self.water, internet: self.internet, phone: self.phone, description: self.description, occupied: self.occupied, preference: self.preference.isEmpty ?  "Anyone" : self.preference, createdAt: self.createdAt, updatedAt: self.updatedAt)
        }
    }
    
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
//        func previousPage(baseurl: String) -> String {
//            var copy = self
////            copy.page = (page == nil || page! <= 1) ? 1 :( page! - 1)
//            if let page = page, page > 1 {
//                copy.page = page - 1
//            }else {
//                copy.page = 1
//            }
//            var components = URLComponents()
//            components.scheme = "http"
//            components.host = "localhost"
//            components.port = 8080
//            components.path = "/api/v1"
//            components.queryItems = getQeury(query: copy)
//            return  (components.url?.absoluteString ?? "")
//        }
//
//        func nextPage(baseurl: String, totalPage: Int) -> String {
//            var copy = self
////            copy.page = (page == nil || page! <= 1) ? 1 :( page! - 1)
//            if let page = page, page < totalPage {
//                copy.page = page + 1
//            }else {
//                copy.page = 1
//            }
//
//            var components = URLComponents()
//            components.scheme = "http"
//            components.host = "localhost"
//            components.port = 8080
////            components.path = ""
//            components.queryItems = getQeury()
//            return components.url?.absoluteString ?? ""
//        }
        
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
            let images = r.vimages.components(separatedBy: ",")
            let coverImage: String = baseUrl + "/uploads/" + (images.first ?? "")
            return .init(
                coverImage: coverImage,
                nepaliPrice: (self.price ?? 0).getNumberWithNepaliFormat() ?? "",
                city: $city.value?.responseFrom(baseUrl: baseUrl),
                user: $user.value?.getBasicProfile() ,
                id: r.id,
                price: r.price,
                images: images.map {baseUrl + "/uploads/" + $0},
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
    
    extension Room {
        struct Entity: Content {
            var images: [File]
            var city_id: Int
        }
    }
    
    extension Double {
        func getNumberWithNepaliFormat( precision: Int = 2) -> String? {
            let number = self
            
            if  number != 0 {
                let nsNumber = NSNumber.init(value: number)
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = precision
                formatter.usesGroupingSeparator = true
                formatter.groupingSize = 3
                formatter.secondaryGroupingSize = 2
                formatter.maximumFractionDigits = precision
                let result = formatter.string(for: nsNumber)
                return result
            }
            return nil
        }
        
        func getShortCurrency( precision: Int = 2) -> String? {
            let number = self
            
            if  number != 0 {
                if number < 1_000 {
                    return "Rs.\(number)"
                }else if number >= 1_000 && number < 10_000 {
                    let remainder = number.remainder(dividingBy: 1000)
                    return remainder  == 0 ? "1K" : "1.\(remainder)k"
                } else if number >= 10_000 && number < 100_000 {
                    let remainder = number.remainder(dividingBy: 10_000)
                    return remainder == 0 ? "10K" : "10.\(remainder)k"
                }else if number >= 100_000  {
                    let remainder = number.remainder(dividingBy: 100_000)
                    return remainder  == 0 ? "100K" : "100.\(remainder)k"
                }
                
                //            let nsNumber = NSNumber.init(value: number)
                //            let formatter = NumberFormatter()
                //            formatter.numberStyle = .decimal
                //            formatter.maximumFractionDigits = precision
                //            formatter.usesGroupingSeparator = true
                //            formatter.groupingSize = 3
                //            formatter.secondaryGroupingSize = 2
                //            formatter.maximumFractionDigits = precision
                //            let result = formatter.string(for: nsNumber)
                //            return result
            }
            return nil
        }
    }



extension Double {
    var toString: String {
        return "\(self)"
    }
}



extension Int {
    var toString: String {
        return "\(self)"
    }
}



extension Bool {
    var toString: String {
        return "\(self)"
    }
}
