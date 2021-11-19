//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation



extension Room {
    func responseFrom(baseUrl: String)-> Room.Output {
        let r = self
        let images = r.getImages(baseUrl: baseUrl)
        let coverImage: String = images.first ?? ""
        return  Room.Output.init(
            coverImage: coverImage,
            nepaliPrice: (self.price ?? 0).getNumberWithNepaliFormat() ?? "",
            city: $city.value?.responseFrom(baseUrl: baseUrl),
            user: $user.value?.getBasicProfile() ,
            id: r.id,
            price: r.price,
            images: images,
            type: r.type,
            noOfRooms: r.noOfRooms,
            kitchen: r.kitchen,
            floor: r.floor,
            lat: r.lat,
            long: r.long,
            address: r.address,
            district: r.district,
            state: r.state,
            localGov: r.localGov,
            parking: r.parking,
            water: r.water,
            internet: r.internet,
            phone: r.phone,
            description: r.description,
            occupied: r.occupied,
            preference: r.preference,
            createdAt: r.createdAt,
            updatedAt: r.updatedAt,
            features: r.getFeautres(),
            timesAgo: r.createdAt?.timeAgoDisplay() ?? "",
            verified: r.verified
        )
    }
}
