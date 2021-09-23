//
//  File.swift
//  
//
//  Created by ccr on 03/09/2021.
//


import Fluent
import Vapor
import JWT


final class UserContainer : Codable {
    let user : User?

    enum CodingKeys: String, CodingKey {

        case user = "user"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }

}



//{"token":  "ya29.a0ARrdaM9gHoh1LJhgJ8RdafjPW-63rtfWhOycLpOk71yYKbSSZ5DG7VPZsMKmBlF7jEV3WO6jhdxCHgut-WQXitMG3xyUQQCcDcwrBVCK6x90v2WR3SNK2E-oAjgck0UGTR2PIGtFvkOwCqo5GxiX1DN9geoQ",
//            "user_id": "",
//            "provider": "google",
//            "imageurl": "https://lh3.googleusercontent.com/a-/AOh14Gh2TajCMWMAaYut5Ti4P12od6xMBbapPvebcRRc=s1337",
//            "name": "" ,
//            "email": "",
//            "fuid": "",
//            "fcm":"eF2s6tvi40mFs4hin8FF-B:APA91bHEDJT3rCZfDmCxJd9fR_NPNCqgCwViuyPlPNaTfqYKceB_ZzWBwOByrE0WuviD9jaztOIManszCcwm8kk0S0kqCfkNRlgfquxfINgPLKCpp-IVfQEgwITzx5kpPiEXIJhvftJU"
//            }

final class User : Model, Content {
    static let schema = "users"

    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "email")
    var email : String?
    
    @Field(key: "imageurl")
    var imageurl : String?
    
    @Field(key: "name")
    var name : String?
    
    @Field(key: "token")
    var token : String?
    
    
    @Field(key: "fcm")
    var fcm : String?
    
    var authToken: String?
      
    
//    @Field(key: "user_id")
//    var user_id : String?
    
    @Field(key: "provider")
    var provider : String?
    
    @Timestamp(key: "inserted_at", on: .create)
        var createdAt: Date?

    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    

    init() { }
    
    init(id: Int?,
         email: String,
         imageurl: String,
         name : String?,
         token : String?,
         provider : String?,
         fcm: String?) {
        self.email = email
        self.id = id
        self.imageurl = imageurl
        self.name = name
        self.token = token
        self.provider = provider
        self.fcm = fcm
    }
    
    
    
   
    
}

//{
//  "aud": "finder",
//  "exp": 1633156482,
//  "iat": 1630737282,
//  "iss": "finder",
//  "jti": "ae69be80-6309-4b36-abc3-b3eb53df66f0",
//  "nbf": 1630737281,
//  "sub": "1",
//  "typ": "access"
//}


// JWT payload structure.
struct JwtModel: JWTPayload {
    // Maps the longer Swift property names to the
    // shortened keys used in the JWT payload.
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
    }

    // The "sub" (subject) claim identifies the principal that is the
    // subject of the JWT.
    var subject: SubjectClaim

    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim

    // Custom data.
    // If true, the user is an admin.
    

    // Run any additional verification logic beyond
    // signature verification here.
    // Since we have an ExpirationClaim, we will
    // call its verify method.
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}




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
        return User(id: nil, email: email ?? "", imageurl: picture ?? "", name: name ?? "", token: nil, provider: nil, fcm: "")
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



struct TestPayload: JWTPayload {
    // Maps the longer Swift property names to the
    // shortened keys used in the JWT payload.
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        
    }

    // The "sub" (subject) claim identifies the principal that is the
    // subject of the JWT.
    var subject: SubjectClaim

    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim

    // Custom data.
    // If true, the user is an admin.
    

    // Run any additional verification logic beyond
    // signature verification here.
    // Since we have an ExpirationClaim, we will
    // call its verify method.
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}

