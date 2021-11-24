//
//  File.swift
//  File
//
//  Created by ccr on 24/11/2021.
//

import Foundation
import Vapor

class ReportController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("reports")
        route.post( use: create)
    }
    
    
    func create(req: Request) throws -> EventLoopFuture<CommonResponse<Report.Output>>{
        let input = try req.content.decode(Report.Input.self)
    
        return input.report.save(on: req.db).map {
            let message = Report.Output(message: "Thank you. Your message has been recieved and will review your request shortly")
            return CommonResponse.init(data: message)
        }
        
    }
}
