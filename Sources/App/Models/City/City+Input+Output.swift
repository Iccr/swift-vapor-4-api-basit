//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Vapor

extension City {
    
    struct Output: Content {
        var id: Int?
        var name : String?
        var image : String?
        var count: Int?
        var lat: Double?
        var long: Double?
        var description : String?
        var createdAt: Date?
        var updatedAt: Date?
    }
    
    struct Input: Content {
        var id: Int?
        var name : String
        var image : String?
        var description : String?
        var lat: Double?
        var long: Double?
    }
    
    struct Query: Content {
        var alert: String
        var alertLevel: Int = 1
    }
    
    struct IDInput: Content {
        var id: Int
    }
    
}

extension City.Input {
    var city: City {
        return .init(name: self.name, image: self.image, description: self.description, lat: self.lat, long: self.long)
    }
}
