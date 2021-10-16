//
//  File.swift
//  
//
//  Created by ccr on 13/10/2021.
//

import Foundation

import Vapor
import ImperialCore

class LoginWebController {
    func signIn(req: Request) -> EventLoopFuture<View> {
        return req.view.render("login")
    }
}
