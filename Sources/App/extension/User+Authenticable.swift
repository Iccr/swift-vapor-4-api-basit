//
//  File.swift
//  
//
//  Created by ccr on 12/11/2021.
//

import Foundation
import Vapor
import Fluent


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


