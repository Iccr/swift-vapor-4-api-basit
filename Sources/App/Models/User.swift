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
    
    
    var authToken: String?
      
    
//    @Field(key: "user_id")
//    var user_id : String?
    
    @Field(key: "provider")
    var provider : String?
    

    init() { }
    
    init(id: Int?,
         email: String,
         imageurl: String,
         name : String?,
         token : String?,
         provider : String? ) {
        
        self.id = id
        self.imageurl = imageurl
        self.name = name
        self.token = token
        self.provider = provider
    }
    
   
    
}




// JWT payload structure.
struct JwtModel: JWTPayload {
    // Maps the longer Swift property names to the
    // shortened keys used in the JWT payload.
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case isAdmin = "admin"
    }

    // The "sub" (subject) claim identifies the principal that is the
    // subject of the JWT.
    var subject: SubjectClaim

    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim

    // Custom data.
    // If true, the user is an admin.
    var isAdmin: Bool

    // Run any additional verification logic beyond
    // signature verification here.
    // Since we have an ExpirationClaim, we will
    // call its verify method.
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}

