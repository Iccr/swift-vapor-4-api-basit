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
        return .init(id: city.id , name: city.name, image: baseUrl + (city.imageUrl ?? ""), count: city.$rooms.value?.count, description: city.description)
    }
}

