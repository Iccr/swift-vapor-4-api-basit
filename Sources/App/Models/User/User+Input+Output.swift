//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//


import Vapor


extension User {
    struct Input: Content {
        var email: String?
        var imageurl: String?
        var name : String?
        var token : String
        var appleUserIdentifier: String?
        var provider : String
        var fcm: String?
    }
    
    struct Output: Content {
        var id: Int?
        var name: String?
        var token: String?
        var image: String?
        var email:String?
    }
    
    func responsefrom() -> User.Output {
        return .init(id: self.id, name: self.name, token: self.token, image: self.image, email: self.email)
    }
}


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
