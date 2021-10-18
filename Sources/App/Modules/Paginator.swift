//
//  File.swift
//  
//
//  Created by ccr on 18/10/2021.
//

import Foundation
import Fluent

struct PageModel: Encodable {
    // pagination
    // < 1 , 2 , 3, >
    var previous: String?
    var next: String?
    var currentPage: Int
    var totalPage: Int
    var loops: [Int]
    var per: Int
    var page: Int
   
}


class Paginator<T> {
    var page: Page<T>
    var components: URLComponents
    var otherQueries: [URLQueryItem] = []
    
    init(page: Page<T>, otherQueries: [URLQueryItem]) {
        self.page = page
        self.otherQueries = otherQueries
        self.components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8080
    }
    
    
    
    func previousPage(baseurl: String) -> String? {
        var pageItem: URLQueryItem!
        if let _pageItem = otherQueries.filter { $0.name == "page" }.first  {
            pageItem = _pageItem
        }else {
            pageItem = URLQueryItem(name: "page", value: "1")
            otherQueries.append(pageItem)
        }
        pageItem.value =  page.metadata.page <= 1 ? "1" : "\(page.metadata.page - 1)"
        if let  index = otherQueries.firstIndex(where: {$0.name == "page"}) {
            otherQueries.remove(at: index)
            otherQueries.insert(pageItem, at: index)
        }
        
        var components = URLComponents()
        components.queryItems = otherQueries
        if let url = components.url?.absoluteString {
            return baseurl + url
        }
        return  nil
    }
    
    func nextPage(baseurl: String) -> String? {
        
//        total = 10
//        per = 3
//        page = 3
        
        let total = page.metadata.total
        let result = total.quotientAndRemainder(dividingBy: page.metadata.per)
        let maxPage = result.remainder == 0 ? result.quotient : result.quotient + 1
        var pageItem: URLQueryItem!
        
        if let _pageItem = otherQueries.filter { $0.name == "page" }.first {
            pageItem = _pageItem
        } else {
            pageItem = URLQueryItem(name: "page", value: "\(page.metadata.page + 1)")
            otherQueries.append(pageItem)
        }
        pageItem.value =  page.metadata.page >= maxPage ? "\(maxPage)" : "\(page.metadata.page + 1)"
        if let  index = otherQueries.firstIndex(where: {$0.name == "page"}) {
            otherQueries.remove(at: index)
            otherQueries.insert(pageItem, at: index)
        }else {
            otherQueries.append(pageItem)
        }
        
        var components = URLComponents()
        components.queryItems = otherQueries
        if let url = components.url?.absoluteString {
            return baseurl + url
        }
        return  nil
    }
}

