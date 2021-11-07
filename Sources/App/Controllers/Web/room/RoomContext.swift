//
//  File.swift
//  
//
//  Created by ccr on 22/10/2021.
//

import Foundation
import Fluent
import Vapor


extension Room {
    struct Context: Encodable {
        var title: String
        var items: [Room.Output]
        var page: Page<Room.Output>
        var query: Room.Querry
        var tags: String
        var user: User?
        var pageModel: PageModel
        var isAdmin: Bool
        var alert: String?
        var alertLevel: Int?
    }
    
    static func getContext(baseUrl: String,
                           page: Page<Room.Output>,
                           query: Room.Querry,
                           user: User?) -> Room.Context {
            
        let searchTags = ["type", "internet", "kitchen", "floor", "parking", "water", "preference", "city"]
        let tag = query.getQeury().filter {searchTags.contains($0.name.lowercased())}
            .map{ "\($0.value ?? "")" }.joined(separator: ", ")
        
        let paginator = Paginator(
            page: page,
            otherQueries: query.getQeury()
        )
        let previous = paginator.previousPage(baseurl: baseUrl)
        let next = paginator.nextPage(baseurl: baseUrl)
        let maxPage =  Int(ceil(Double(page.metadata.total)/Double(page.metadata.per)))
        
        
        
        return Room.Context(
         title: "Rooms",
         items: page.items,
         page: page,
         query: query,
         tags: tag,
         user: user,
         pageModel: PageModel(
             previous: previous,
             next: next,
             currentPage: page.metadata.page,
             totalPage: maxPage,
             loops: maxPage == 0 ? [] : Array(1...maxPage),
             per: page.metadata.per,
             page: page.metadata.page
         ),
         isAdmin: user?.isAdmin ?? false,
         alert: query.alert,
         alertLevel: query.alertLevel ?? 1
         
        )
    }
    
    
}
