//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation
import Vapor

struct AppAlert: Content {
    var alert: String?
    var priority: Int? = 1 // 0 none, 1 info, 2 warning, 3 error
}
