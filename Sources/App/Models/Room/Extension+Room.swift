//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation
import Vapor

extension Room {
    func getImages(baseUrl: String) -> [String] {
        let images = self.vimages.components(separatedBy: ",")
        return images.map {
            if let ext = URL.init(string: $0)?.pathExtension, !ext.isEmpty {
                return baseUrl + "/uploads/" + $0
            }else {
                return baseUrl + "/uploads/" + $0 + ".jpg"
            }
        }
    }
}


extension Room {
    struct Entity: Content {
        var images: [File]
        var city_id: Int
    }
}

