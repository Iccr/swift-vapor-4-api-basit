//
//  File.swift
//  File
//
//  Created by ccr on 23/11/2021.
//

import Foundation


final class AppVersion: Model, Content {
    static let schema: String = "app_versions"
    
    @ID(custom: "id")
    var id: Int?

    @OptionalField(key: "ios")
    var ios : String?
    
    @OptionalField(key: "status")
    var android : android?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    // When this Planet was last updated.
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: Int? = nil, ios: String?, android: String?) {
        self.id = id
        self.ios = ios
        self.android = android
    }
}
