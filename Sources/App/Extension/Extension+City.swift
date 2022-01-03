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
       
        let valid = (city.$rooms.value ?? []).filter({$0.verified == true}).filter({$0.occupied == false})
            
        return .init(id: city.id , name: city.name, nepaliName: city.nepaliName, image: imageUrl, count: valid.count, lat: city.lat, long: city.long, description: city.description)
    }
}

