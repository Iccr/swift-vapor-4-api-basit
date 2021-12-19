//
//  File.swift
//  
//
//  Created by ccr on 19/12/2021.
//


import Vapor

extension ApiKey {
    
    struct Output: Content {
        var id: Int?
        var apiKey : String?
        var createdAt: Date?
        var updatedAt: Date?
    }
    
    struct Input: Content {
        var id: Int?
        var apiKey : String?
    }
    
    struct Query: Content {
        var alert: String
        var alertLevel: Int = 1
    }
    
    struct IDInput: Content {
        var id: Int
    }
    
}

extension ApiKey.Input {
    var apiKey: ApiKey {
        return .init(
            apiKey: self.apiKey
        )
    }
}
