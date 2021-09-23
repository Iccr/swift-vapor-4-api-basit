//
//  File.swift
//  
//
//  Created by ccr on 04/09/2021.
//

import ImperialGoogle
import Vapor
import Fluent

struct ImperialController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    
  }
    
}


class SocialSession {
    func verify(token: String, provider: String, req: Request) throws -> GoogleAuthResponseModel {
        return try verifyGoogle(token: token, req: req).wait()
 
        
    }
    
    func verifyGoogle(token: String, req: Request) -> EventLoopFuture<GoogleAuthResponseModel> {
        let urlString = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=" + token
        let url = URI.init(string: urlString)
        
        return req.client.get(url).flatMapThrowing { res -> GoogleAuthResponseModel in
            let response = try res.content.decode(GoogleAuthResponseModel.self)
            return response
            
        }

    }
        

//    defp verify_facebook_token(token) do
//        url =
//          "https://graph.facebook.com/me?fields=name,first_name,last_name,email,picture&access_token=" <>
//            token
//
//        {:ok, response} =
//          Task.async(fn -> HTTPoison.get(url) end)
//          |> Task.await()
//
//        parse_fb_response(response)
//      end
    
}
