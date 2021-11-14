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
    
    func create(req: Request) throws -> EventLoopFuture<CommonResponse<User>> {
        let input = try req.content.decode(User.Input.self)
        guard let provider = AuthProvider.init(rawValue: input.provider ?? "") else {
            throw Abort(.badRequest, reason: "provider not found")
        }
        
        switch  provider {
            case .google:
                return try signUpWithGoogle(req: req, input: input).map(CommonResponse.init)
            case .facebook:
                return signUpWithFacebook(req: req, input: input).map(CommonResponse.init)
            case .apple:
                return try signUpWithApple(req: req).map(CommonResponse.init)
        }
    }
    
    func signUpWithGoogle(req: Request, input: User.Input) throws -> EventLoopFuture<User> {
        let result =   SocialSession().verifyGoogle(token: input.token ?? "", req: req)
        return result.flatMapThrowing { response -> User in
            let user = response.user
            if let error = response.error {
                throw (Abort(.unauthorized, reason: error))
            }
            return user
        }.flatMap { user in
            return User.findByEmail(user.email ?? "", req: req)
                .flatMap { _user in
                    if _user == nil {
                        return LoginController.signUp(
                            name: user.name,
                            email: user.email,
                            provider: AuthProvider.google.rawValue,
                            req: req
                        )
                    } else {
                        return LoginController.signInWithEmail(
                            appleIdentifier: nil,
                            email: _user?.email ?? "",
                            name: _user?.name,
                            req: req
                        )
                    }
                }
        }
            
        
    }
    
    func signUpWithFacebook(req: Request, input: User.Input) -> EventLoopFuture<User> {
        let result =   SocialSession().verifyFacebook(token: input.token ?? "", req: req)
        return result.flatMap { response in
            let user = User.getUser(from: response)
            
            return User.findByEmail(user.email ?? "", req: req)
                .flatMap { _user in
                    if _user == nil {
                        return LoginController.signUp(
                            name: user.name,
                            email: user.email,
                            provider: AuthProvider.facebook.rawValue,
                            req: req
                        )
                    } else {
                        return LoginController.signInWithEmail(
                            appleIdentifier: nil,
                            email: _user?.email ?? "",
                            name: _user?.name,
                            req: req
                        )
                    }
                }
        }
    }
}


extension LoginController {
    struct SIWARequestBody: Content {
        let firstName: String?
        let lastName: String?
        let appleIdentityToken: String
    }
    
    func signUpWithApple(req: Request) throws -> EventLoopFuture<User> {
        let userBody = try req.content.decode(SIWARequestBody.self)
        
        return req.jwt.apple.verify(
            userBody.appleIdentityToken,
            applicationIdentifier: Apple.SIWA.applicationIdentifier
        ).flatMap { appleIdentityToken in
            User.findByAppleIdentifier(appleIdentityToken.subject.value, req: req)
                .flatMap { user in
                    var name: String? = nil
                    if let firstname = userBody.firstName, let lastname = userBody.lastName {
                        name = firstname +  " " + lastname
                    }
                    if user == nil {
                        guard let _ = appleIdentityToken.email else {
                            return req.eventLoop.makeFailedFuture(UserError.siwaEmailMissing)
                        }
                        
                        return LoginController.signUp(
                            appleUserIdentifier: appleIdentityToken.subject.value,
                            name: name,
                            email: appleIdentityToken.email,
                            provider: AuthProvider.apple.rawValue,
                            req: req)
                    } else {
                        return LoginController.signInWithApple(
                            appleIdentifier: appleIdentityToken.subject.value,
                            email: appleIdentityToken.email,
                            name: name,
                            req: req
                        )
                    }
                }
        }
    }
    
    // 1
    static func signUp(
        appleUserIdentifier: String? = nil,
        name: String? = nil,
        email: String? = nil,
        provider: String,
        req: Request
    ) -> EventLoopFuture<User> {
        return User.assertUniqueEmail(email ?? "", req: req).flatMap {
            let user: User = .init( id: nil, email: email ?? "", imageurl: nil, name: name, token: nil, appleUserIdentifier: appleUserIdentifier, provider: provider, fcm: nil)
            // 5
            return user.save(on: req.db)
                .flatMap {
                    guard let accessToken = try? user.createAccessToken(req: req) else {
                        return req.eventLoop.future(error: Abort(.internalServerError))
                    }
                    return accessToken.save(on: req.db).flatMap {
                        user.token = accessToken.value
                        return user.update(on: req.db).map {
                            user
                        }
                    }
                }
        }
    }
    
    static func signInWithApple(
        appleIdentifier: String,
        email: String? = nil,
        name: String? = nil,
        
        req: Request
    )  -> EventLoopFuture<User> {
        // 2
        
        return User.findByAppleIdentifier(appleIdentifier, req: req)
            // 3
            .unwrap(or: Abort(.notFound))
            .flatMap { user -> EventLoopFuture<User> in
                // 4
                if let email = email {
                    user.email = email
                    if let name = name {
                        user.name = name
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
    
    static func signInWithEmail(
        appleIdentifier: String? = nil,
        email: String,
        name: String? = nil,
        
        req: Request
    )  -> EventLoopFuture<User> {
        return  User.findByEmail(email, req: req)
            .unwrap(or: Abort(.notFound))
            .flatMap { user -> EventLoopFuture<User> in
                user.email = email
                if let name = name {
                    user.name = name
                }
                return user.update(on: req.db).map {
                    user
                }
//                    .transform(to: user)
            }
            .flatMap { user in
                guard let accessToken = try? user.createAccessToken(req: req) else {
                    return req.eventLoop.future(error: Abort(.internalServerError))
                }
//                return accessToken.save(on: req.db).flatMapThrowing {
                    user.token = accessToken.value
                return req.eventLoop.future(user)
//                }
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

