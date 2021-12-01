//
//  File.swift
//  
//
//  Created by ccr on 23/10/2021.
//

import Foundation
import Vapor

struct AppInfo: Content {
    var banners: [Banner.Output] = []
    var cities: [City.Output] = []
    var info: AppVersion.Output?
    var featured: [Room.Output] = []
}
