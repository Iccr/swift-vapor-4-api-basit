//
//  File.swift
//  
//
//  Created by ccr on 04/09/2021.
//

import ImperialGoogle
import Vapor
import Fluent


class SocialSession {
    func verifyGoogle(token: String, req: Request) -> EventLoopFuture<GoogleAuthResponseModel> {
        let urlString = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=" + token
        let url = URI.init(string: urlString)
        return req.client.get(url).flatMapThrowing { res -> GoogleAuthResponseModel in
            let response = try res.content.decode(GoogleAuthResponseModel.self)
            return response
        }
    }

    func verifyFacebook(token: String, req: Request) -> EventLoopFuture<FacebookResponseModel> {
        let urlString = "https://graph.facebook.com/me?fields=name,first_name,last_name,email&access_token=" + token
        let url = URI.init(string: urlString)
        return req.client.get(url) {req in
            req.headers.add(name: .accept, value: "*/*")
            print(req)
        }
            .flatMapThrowing { res -> FacebookResponseModel in
            let response = try res.content.decode(FacebookResponseModel.self)
                if response.error != nil {
                    throw Abort(.unauthorized)
                }
            return response
        }
    }
}
