//
//  File.swift
//  
//
//  Created by ccr on 09/12/2021.
//

import Foundation
import Fluent
import Vapor

final class AppPage : Model, Content {
    static let schema = Schema.Pages
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name : String?

    @Field(key: "eng")
    var eng : String?

    @Field(key: "nep")
    var nep : String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: Int? = nil, name: String, eng: String?, nep: String?) {
        self.id = id
        self.name = name
        self.eng = eng
        self.nep = nep
    }
}

