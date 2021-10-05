//
//  File.swift
//  
//
//  Created by ccr on 03/09/2021.
//

import Foundation


import Fluent
import Vapor
import JWT

enum AuthProvider: String  {
    case google
    case facebook
    case apple
}

struct LoginController: RouteCollection {

    
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("login")
        
        //        todos.post(use: create)
        
        todos.group(":loginID") { todo in
            todo.delete(use: delete)
        }
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        let input = try req.content.decode(UserContainer.self).user
        guard let provider = AuthProvider.init(rawValue: input?.provider ?? "") else {
            throw Abort(.badRequest, reason: "provider not found")
        }
        
        switch  provider {
            case .google:
                return  signUpWithGoogle(req: req, input: input)
            case .facebook:
                return signUpWithFacebook(req: req, input: input)
            case .apple:
               return try signUpWithApple(req: req)
        }
    }
    
    func signUpWithGoogle(req: Request, input: User?)  -> EventLoopFuture<User> {
        
        
        let result =   SocialSession().verifyGoogle(token: input?.token ?? "", req: req)
//            .verify(token: input?.token ?? "", provider: "google", req: req, input: input)
        
        return result.flatMap { response in
            let user = response.user
            
            let first = User.query(on: req.db)
                .filter(\.$email == response.user.email)
                .first()
            
            
            
            return first.flatMap { oUser -> EventLoopFuture<User> in
                if let user = oUser {
                    user.fcm = user.fcm
                    return user.update(on: req.db).map {
                        return user
                    }
                    
                }
                return user.create(on: req.db).flatMapThrowing {
                    let payload = JwtModel(
                       subject: SubjectClaim(value: "\(user.id!)"),
                       expiration: .init(value: .distantFuture)
                   )
                   let generatedToken = try req.jwt.sign(payload)
//                    print(user.token ?? "")
                   user.token = generatedToken
                   // return response
                   return  user
                }
            }
        }
    }
    
    func signUpWithFacebook(req: Request, input: User?) -> EventLoopFuture<User> {
        
        
        let result =   SocialSession().verifyFacebook(token: input?.token ?? "", req: req)
//            .verify(token: input?.token ?? "", provider: AuthProvider.facebook.rawValue, req: req, input: input)

        
        return result.flatMap { response in
            let user = User.getUser(from: response)
            
            let first = User.query(on: req.db)
                .filter(\.$email == user.email)
                .first()
            
            
            
            return first.flatMap { oUser -> EventLoopFuture<User> in
                if let user = oUser {
                    user.fcm = user.fcm
                    return user.update(on: req.db).map {
                        return user
                    }
                    
                }
                return user.create(on: req.db).flatMapThrowing {
                    let payload = JwtModel(
                       subject: SubjectClaim(value: "\(user.id!)"),
                       expiration: .init(value: .distantFuture)
                   )
                   let generatedToken = try req.jwt.sign(payload)
//                    print(user.token ?? "")
                   user.token = generatedToken
                   // return response
                   return  user
                }
            }
        }
    }
    
    
    struct SIWARequestBody: Content {
      let firstName: String?
      let lastName: String?
      let appleIdentityToken: String
    }
    
    func signUpWithApple(req: Request) throws -> EventLoopFuture<User> {
      let userBody = try req.content.decode(SIWARequestBody.self)

      return req.jwt.apple.verify(
        userBody.appleIdentityToken,
        applicationIdentifier: Env.SIWA.applicationIdentifier
      ).flatMap { appleIdentityToken in
        User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req)
          .flatMap { user in
            if user == nil {
              return LoginController.signUp(
                appleIdentityToken: appleIdentityToken,
                firstName: userBody.firstName,
                lastName: userBody.lastName,
                req: req
              )
            } else {
              return LoginController.signIn(
                appleIdentityToken: appleIdentityToken,
                firstName: userBody.firstName,
                lastName: userBody.lastName,
                req: req
              )
            }
          }
      }
    }
    
    // 1
    static func signUp(
      appleIdentityToken: AppleIdentityToken,
      firstName: String? = nil,
      lastName: String? = nil,
      req: Request
    ) -> EventLoopFuture<User> {
      // 2
      guard let email = appleIdentityToken.email else {
        return req.eventLoop.makeFailedFuture(UserError.siwaEmailMissing)
      }
      // 3
      return User.assertUniqueEmail(email, req: req).flatMap {
        // 4
        var name: String? = nil
        if let firstname = firstName, let lastname = lastName {
            name = firstname +  " " + lastname
        }
        
        let user: User = .init( id: nil, email: email, imageurl: nil, name: name, token: nil, appleUserIdentifier: appleIdentityToken.subject.value, provider: nil, fcm: nil)
        // 5
        return user.save(on: req.db)
          .flatMap {
            // 6
            guard let accessToken = try? user.createAccessToken(req: req) else {
              return req.eventLoop.future(error: Abort(.internalServerError))
            }
            // 7
            return accessToken.save(on: req.db).flatMapThrowing {
              // 8
               User.init( id: nil, email: email, imageurl: nil, name: name, token: nil, appleUserIdentifier: appleIdentityToken.subject.value, provider: nil, fcm: nil)
            }
        }
      }
    }
    
    // 1
    static func signIn(
      appleIdentityToken: AppleIdentityToken,
      firstName: String? = nil,
      lastName: String? = nil,
      req: Request
    ) -> EventLoopFuture<User> {
      // 2
      User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req)
        // 3
        .unwrap(or: Abort(.notFound))
        .flatMap { user -> EventLoopFuture<User> in
          // 4
          if let email = appleIdentityToken.email {
            user.email = email
            if let firstName = firstName, let lastName = lastName {
                user.name = firstName + " " + lastName
            }
           

            return user.update(on: req.db).transform(to: user)
          } else {
            return req.eventLoop.future(user)
          }
        }
        // 5
        .flatMap { user in
          guard let accessToken = try? user.createAccessToken(req: req) else {
            return req.eventLoop.future(error: Abort(.internalServerError))
          }
          return accessToken.save(on: req.db).flatMapThrowing {
            // 6
            user.token = accessToken.value
            return user
          }
      }
    }
    
    
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}






enum UserError {
  case emailTaken
  case siwaEmailMissing
  case siwaInvalidState
}
extension UserError: AbortError {
  var description: String { reason }

  var status: HTTPResponseStatus {
    switch self {
    case .emailTaken: return .conflict
    case .siwaEmailMissing: return .badRequest
    case .siwaInvalidState: return .badRequest
    }
  }

  var reason: String {
    switch self {
    case .emailTaken: return "A user with this email address is already registered."
    case .siwaEmailMissing: return "The email is missing from Apple Identity Token. Try to revoke access for this application on https://appleid.apple.com and try again."
    case .siwaInvalidState: return "Invalid state."
    }
  }
}
