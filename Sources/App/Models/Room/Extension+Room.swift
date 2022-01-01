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
    
        
        var  images: [String] = self.vimages?.components(separatedBy: ",").filter({!$0.isEmpty})
        ?? []
        if images.isEmpty {
            images = [baseUrl + "/samples/placeholder.jpg"]
            return images
        }
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

