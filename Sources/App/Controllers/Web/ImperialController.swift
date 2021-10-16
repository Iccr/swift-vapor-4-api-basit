//
//  File.swift
//  
//
//  Created by ccr on 13/10/2021.
//

import Foundation
import Vapor
import ImperialCore
import ImperialGoogle


struct ImperialController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
       
        guard let googleCallbackURL =
          Environment.get("GOOGLE_CALLBACK_URL") else {
            fatalError("Google callback URL not set")
        }
        try routes.oAuth(
          from: Google.self,
          authenticate: "login-google",
          callback: googleCallbackURL,
          scope: ["profile", "email"],
          completion: processGoogleLogin)
    }
    
    func processGoogleLogin(request: Request, token: String)
      throws -> EventLoopFuture<ResponseEncodable> {
        
        return request.eventLoop.future(request.redirect(to: "/"))
    }
    
    
}


struct GoogleUserInfo: Content {
  let email: String
  let name: String
}


extension Google {
  // 1
  static func getUser(on request: Request)
    throws -> EventLoopFuture<GoogleUserInfo> {
      // 2
      var headers = HTTPHeaders()
      headers.bearerAuthorization =
        try BearerAuthorization(token: request.accessToken())

      // 3
      let googleAPIURL =
        "https://www.googleapis.com/oauth2/v1/userinfo?alt=json"
   
      // 4
    
    return  request
        .client
        .get(
            URI.init(string: googleAPIURL),
            headers: headers)
        .flatMapThrowing({ (response: ClientResponse) in
        guard response.status == .ok else {
            if response.status == .unauthorized {
                throw Abort.redirect(to: "/login-google")
            }else {
                throw Abort(.internalServerError)
            }
        }
        return try response.content.decode(GoogleUserInfo.self)
    })
    
//      return try request
//        .client()
//        .get(googleAPIURL, headers: headers)
//        .map(to: GoogleUserInfo.self) { response in
//        // 5
//        guard response.http.status == .ok else {
//          // 6
//          if response.http.status == .unauthorized {
//            throw Abort.redirect(to: "/login-google")
//          } else {
//            throw Abort(.internalServerError)
//          }
//        }
//        // 7
//        return try response.content
//          .syncDecode(GoogleUserInfo.self)
//      }
  }
}
