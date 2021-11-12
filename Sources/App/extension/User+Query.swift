//
//  File.swift
//  
//
//  Created by ccr on 12/11/2021.
//

import Foundation
import Vapor
import Fluent

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
