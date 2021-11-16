//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation


extension City {
    func responseFrom(baseUrl: String) ->  City.Output {
        let city = self
        var imageUrl: String? = nil
        if let image = city.imageUrl, !image.isEmpty {
            imageUrl =  baseUrl + image
        }
        return .init(id: city.id , name: city.name, image: imageUrl, count: city.$rooms.value?.count, lat: city.lat, long: city.long, description: city.description)
    }
}

