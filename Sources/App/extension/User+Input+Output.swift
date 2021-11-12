//
//  File.swift
//  
//
//  Created by ccr on 12/11/2021.
//

import Foundation
import Vapor
import Fluent



extension User {
    struct Profile: Codable {
        var id: Int?
        var name: String?
        var email: String?
        var image: String?
    }
    
    struct BasicProfile: Codable {
        var id: Int?
        var name: String?
        var image: String?
    }
    
    func getBasicProfile() -> BasicProfile {
        return .init(id: self.id,name: self.name, image: self.image)
    }
    
    func getProfile() -> User.Profile {
        return Profile(id: self.id , name: self.name, email: self.email, image: self.image)
    }
}


