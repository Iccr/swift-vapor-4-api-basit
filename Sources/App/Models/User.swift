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


final class User : Model, Content {
    static let schema = "users"

    @ID(custom: "id")
    var id: Int?
    
    @Children(for: \.$user)
    var rooms: [Room]
    
    @Field(key: "email")
    var email : String?
    
    @Field(key: "imageurl")
    var imageurl : String?
    
    @Field(key: "name")
    var name : String?
    
    @Field(key: "token")
    var token : String?
    
    @Field(key: "appleUserIdentifier")
    var appleUserIdentifier: String?
    
    @Field(key: "fcm")
    var fcm : String?
    
    var authToken: String?
      
    @Field(key: "provider")
    var provider : String?
    
    @Timestamp(key: "created_at", on: .create)
        var createdAt: Date?


    @Timestamp(key: "updated_at", on: .update)
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
        self.imageurl = imageurl
        self.name = name
        self.token = token
        self.appleUserIdentifier = appleUserIdentifier
        self.provider = provider
        self.fcm = fcm
    }
 
}

extension User {
    struct Profile: Codable {
        var id: Int?
        var name: String?
        var email: String?
        var imageurl: String?
    }
    
    func getProfile() -> User.Profile {
        return Profile(id: self.id , name: self.name, email: self.email, imageurl: self.imageurl)
    }
}


// MARK: - Token Creation
extension User {
  func createAccessToken(req: Request) throws -> Token {
    let expiryDate = Date() + Apple.AccessToken.expirationTime
    let payload = JwtModel(
        subject: SubjectClaim(value: "\(self.id!)"),
        expiration: .init(value: .distantFuture)
    )
    
    let generatedToken = try req.jwt.sign(payload)
    
    return try Token(
      userID: requireID(),
      token: generatedToken,
      expiresAt: expiryDate
    )
  }
}

// MARK: - Helpers
extension User {
  static func assertUniqueEmail(_ email: String, req: Request) -> EventLoopFuture<Void> {
    findByEmail(email, req: req)
      .flatMap {
        guard $0 == nil else {
          return req.eventLoop.makeFailedFuture(UserError.emailTaken)
        }
        return req.eventLoop.future()
    }
  }



  static func findByAppleIdentifier(_ identifier: String, req: Request) -> EventLoopFuture<User?> {
    User.query(on: req.db)
      .filter(\.$appleUserIdentifier == identifier)
      .first()
  }
    
    static func findByEmail(_ email: String, req: Request) -> EventLoopFuture<User?> {
      User.query(on: req.db)
        .filter(\.$email == email)
        .first()
    }
}


extension User {
    static func getUser(from: FacebookResponseModel) -> User {
        return User.init(id: nil, email: from.email ?? "", imageurl: from.picture?.data?.url, name: from.first_name, token: nil, appleUserIdentifier: nil, provider: "facebook", fcm: nil)
    }
}

extension User: Authenticatable {}
extension User: ModelSessionAuthenticatable {}


struct UserAuthenticator: BearerAuthenticator {
    typealias User = App.User

    func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) -> EventLoopFuture<Void> {
        if let payload = try? request.jwt.verify(as: JwtModel.self), let id = Int(payload.subject.value)  {
            return User.query(on: request.db).filter(\.$id == id).first().map { user in
                if let user = user {
                    request.auth.login(user)
                }
            }
        }
       return request.eventLoop.makeSucceededFuture(())
   }
}

