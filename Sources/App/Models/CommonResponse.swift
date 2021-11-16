//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation
import Vapor


struct CommonResponse<T: Content>: Content {
    let data: T
}
