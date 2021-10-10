//
//  File.swift
//  
//
//  Created by ccr on 10/10/2021.
//

import Foundation
import Vapor
import Fluent

class RoomWebControlelr {
    func index(req: Request) throws -> EventLoopFuture<View> {
        
        
        let query = try req.query.decode(Room.Querry.self)
        return RoomStore().getAllRooms(query, req: req).flatMap { page in

            struct RoomContext: Encodable {
                var title: String
                var items: [Room.Output]
                var page: Page<Room.Output>
            }
            return req.view.render("index", RoomContext(title: "Rooms", items: page.items, page: page))

        }
    }
}
