//
//  File.swift
//  
//
//  Created by ccr on 05/10/2021.
//

import Foundation



struct GoogleAuthResponseModel : Codable {
    let sub : String?
    let name : String?
    let given_name : String?
    let family_name : String?
    let picture : String?
    let email : String?
    let email_verified : Bool?
    let locale : String?
    let error: String?

    enum CodingKeys: String, CodingKey {

        case sub = "sub"
        case name = "name"
        case given_name = "given_name"
        case family_name = "family_name"
        case picture = "picture"
        case email = "email"
        case email_verified = "email_verified"
        case locale = "locale"
        case error = "error_description"
    }
    
    var user: User {
        return User(id: nil, email: email ?? "", imageurl: picture ?? "", name: name ?? "", token: nil, appleUserIdentifier: nil, provider: nil, fcm: "")
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sub = try values.decodeIfPresent(String.self, forKey: .sub)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        given_name = try values.decodeIfPresent(String.self, forKey: .given_name)
        family_name = try values.decodeIfPresent(String.self, forKey: .family_name)
        picture = try values.decodeIfPresent(String.self, forKey: .picture)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        email_verified = try values.decodeIfPresent(Bool.self, forKey: .email_verified)
        locale = try values.decodeIfPresent(String.self, forKey: .locale)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
