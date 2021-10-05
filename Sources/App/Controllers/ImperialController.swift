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
//    func verify(token: String, provider: String, req: Request, input: User?) throws ->  EventLoopFuture<GoogleAuthResponseModel> {
//        
//        guard let provider = AuthProvider.init(rawValue: input?.provider ?? "") else {
//            throw Abort(.badRequest, reason: "provider not found")
//        }
//        
//        switch  provider {
//            case .google:
//                let result =   verifyGoogle(token: token, req: req)
//                return result.flatMapThrowing { response in
//                    if let _ = response.error {
//                        throw Abort(.unauthorized)
//                    }
//                    return response
//                }
//                
//            case .facebook:
//                let result =   verifyFacebook(token: token, req: req)
//                return result.flatMapThrowing { response in
//                    if let _ = response.error {
//                        throw Abort(.unauthorized)
//                    }
//                    return response
//                }
//            case .apple:
//                throw Abort(.unauthorized)
//        }
//
//        
//    }
    
    func verifyGoogle(token: String, req: Request) -> EventLoopFuture<GoogleAuthResponseModel> {
        let urlString = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=" + token
        let url = URI.init(string: urlString)
        
        return req.client.get(url).flatMapThrowing { res -> GoogleAuthResponseModel in
            let response = try res.content.decode(GoogleAuthResponseModel.self)
            return response
            
        }

    }
    

//    defp parse_fb_response(response) do
//       jsn = Jason.decode(response.body)
//
//       case jsn do
//         {:ok, %{"error" => %{"message" => message}}} ->
//           {:error, message}
//
//         {:ok, %{"name" => name, "email" => email}} ->
//           {:ok, name, email}
//
//         {:error, _} ->
//           {:error, "not allowed"}
//       end
//     end

    
    func verifyFacebook(token: String, req: Request) -> EventLoopFuture<FacebookResponseModel> {
        let urlString = "https://graph.facebook.com/me?fields=name,first_name,last_name,email&access_token=" + token
        let url = URI.init(string: urlString)
        
        return req.client.get(url) {req in
            req.headers.add(name: .accept, value: "*/*")
            print(req)
        
        }
            .flatMapThrowing { res -> FacebookResponseModel in
            let response = try res.content.decode(FacebookResponseModel.self)
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
