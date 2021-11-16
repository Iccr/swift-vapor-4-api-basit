//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation



extension Room {
    
    func getFeautres() -> [String] {
        var features: [String] = []
        if let no = noOfRooms,  no != 0 {
            features.append("Rooms: \(no)")
        }
        
        if let floor = floor {
            features.append("Floor: \(floor)")
        }
        
        if let internet = internet {
            features.append("internet: \(internet)")
        }
        
        if let parking = parking {
            features.append("parking: \(parking)")
        }
        
        if let water = water {
            features.append("water: \(water)")
        }
        
        if let kitchen = kitchen {
            features.append("kitchen: \(kitchen)")
        }
        return features
    }
}
