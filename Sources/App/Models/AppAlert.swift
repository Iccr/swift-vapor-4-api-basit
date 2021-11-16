//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation
import Vapor

struct AppAlert: Content {
    var message: String?
    var type: Int // 0 none, 1 info, 2 warning, 3 error
}
