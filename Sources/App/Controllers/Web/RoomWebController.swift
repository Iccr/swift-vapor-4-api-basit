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
                var query: Room.Querry
                var tags: String
                var pageModel: PageModel
            }
            // for pagination
            let total = page.metadata.total
            let result = total.quotientAndRemainder(dividingBy: page.metadata.per)
            let maxPage = result.remainder == 0 ? result.quotient : result.quotient + 1
            let paginator = Paginator(
                page: page,
                otherQueries: query.getQeury()
            )
            
            let previous = paginator.previousPage(baseurl: req.baseUrl)
            let next = paginator.nextPage(baseurl: req.baseUrl)
            let searchTags = ["type", "internet", "kitchen", "floor", "parking", "water", "preference", "city"]
            let tag = query.getQeury().filter {searchTags.contains($0.name.lowercased())}
                .map{ "\($0.value ?? "")" }.joined(separator: ", ")
            return req.view.render("index",
                                   RoomContext(
                                    title: "Rooms",
                                    items: page.items,
                                    page: page,
                                    query: query,
                                    tags: tag,
                                    pageModel: PageModel(
                                        previous: previous,
                                        next: next,
                                        currentPage: page.metadata.page,
                                        totalPage: maxPage,
                                        loops: maxPage == 0 ? [] : Array(1...maxPage),
                                        per: page.metadata.per,
                                        page: page.metadata.page
                                    )
                                   )
            )
            
        }
    }
}

