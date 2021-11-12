//
//  File.swift
//  
//
//  Created by ccr on 12/11/2021.
//

import Foundation
import Vapor
import Fluent


extension User {
    enum Role: String, Codable {
        case admin = "1"
        case normalUser = "2"
    }
    
    func hasRole(_ role: Role) -> Bool {
        return self.role == role
    }
    
    var isAdmin: Bool {
        return self.role == .admin
    }
}
