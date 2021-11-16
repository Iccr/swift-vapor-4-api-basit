//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation



struct CommonResponse<T: Content>: Content {
    let data: T
}
