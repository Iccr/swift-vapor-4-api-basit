//
//  File.swift
//  File
//
//  Created by ccr on 13/12/2021.
//

import Vapor



extension AppPage {
    
    struct Output: Content {
        var id: Int?
        var name : String?
        var eng : String?
        var nep: Int?
        var createdAt: Date?
        var updatedAt: Date?
    }
    
    struct Input: Content {
        var id: Int?
        var name : String
        var eng : String?
        var nep: String?
    }
    
//    struct Query: Content {
//        var alert: String
//        var alertLevel: Int = 1
//    }
    
    struct IDInput: Content {
        var id: Int
    }
    
}

extension AppPage.Input {
    var page: AppPage {
        .init(id: self.id, name: self.name, eng: self.eng, nep: self.nep)
    }
}
