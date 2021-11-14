//
//  File.swift
//  
//
//  Created by ccr on 03/09/2021.
//


import Fluent
import Vapor


final class User : Model, Content {
    static let schema = "users"

    @ID(custom: "id")
    var id: Int?
    
    @Children(for: \.$user)
    var rooms: [Room]
    
    @Field(key: "email")
    var email : String?
    
    @Field(key: "image")
    var image : String?
    
   
    
    @Field(key: "name")
    var name : String?
    
    @Field(key: "token")
    var token : String?
    
    @Field(key: "appleUserIdentifier")
    var appleUserIdentifier: String?
    
    @Field(key: "fcm_token")
    var fcm : String?
    
    @Enum(key: "role")
    var role: Role
    
    var authToken: String?
      
    @Field(key: "provider")
    var provider : String?
    
    
  @Field(key: "auth_token")
  var auth_token : String?
    
    @Field(key: "device_id")
    var device_id : String?
    
    
    @Field(key: "device_type")
    var device_type : String?
    
    @Field(key: "fb_id")
    var fb_id : String?
    
    @Field(key: "fb_id")
    var g_id : String?
    
    @Timestamp(key: "createdAt", on: .create)
        var createdAt: Date?


    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    

    init() { }
    
    init(user: User) throws {
      self.id = try user.requireID()
      self.email = user.email
      self.name = user.name
      
    }
    
    init(id: Int?,
         email: String,
         imageurl: String?,
         name : String?,
         token : String?,
         appleUserIdentifier: String?,
         provider : String?,
         fcm: String?) {
        self.email = email
        self.id = id
        self.image = imageurl
        self.name = name
        self.token = token
        self.appleUserIdentifier = appleUserIdentifier
        self.provider = provider
        self.fcm = fcm
    }
 
}





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
}
