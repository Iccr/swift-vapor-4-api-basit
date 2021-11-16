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
    
    struct IDInput: Content {
        var id: Int
    }
}
