//
//  File.swift
//  
//
//  Created by ccr on 08/10/2021.
//

import Foundation
import Vapor

class MyErrorMiddleware: Middleware {
    internal struct ErrorResponse: Codable {
        /// Always `true` to indicate this is a non-typical JSON response.
        /// The reason for the error.
        var message: String
    }
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        return next.respond(to: request)
            .flatMapErrorThrowing { error in
            var reason: String
            var status: HTTPResponseStatus
            var headers: HTTPHeaders
            switch error {
                case let abort as AbortError:
                    // this is an abort error, we should use its status, reason, and headers
                    reason = abort.reason
                    status = abort.status
                    headers = abort.headers
            
                default:
                    // not an abort error, and not debuggable or in dev mode
                    // just deliver a generic 500 to avoid exposing any sensitive error info
                    print("error.localizedDescription")
                    request.logger.log(level: .critical, "Something Went Wrong")
                    request.logger.log(level: .critical, Logger.Message.init(stringLiteral: error.localizedDescription))
                    reason = "Something went wrong."
                    status = .internalServerError
                    headers = [:]
//                    source = nil
            }
            
                let response = Response(status: .ok, headers: headers)
            
            let errorResponse = ErrorResponse( message: reason)
//            json = try JSONEncoder().encode(["error": result.message])
            response.body = try .init(data: JSONEncoder().encode(["error": errorResponse] ))
            response.headers.add(name: .contentType, value: "application/json")
            return response
            
        }
    }
}
