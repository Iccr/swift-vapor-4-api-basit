//
//  File.swift
//  
//
//  Created by ccr on 12/11/2021.
//

import Foundation
import Vapor
import Fluent
import JWT

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
