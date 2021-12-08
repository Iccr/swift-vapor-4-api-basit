//
//  File.swift
//  
//
//  Created by ccr on 05/10/2021.
//

import Foundation
import Vapor

struct FacebookResponseModel: Content {
    let name : String?
    let first_name : String?
    let last_name : String?
    let email : String?
    let picture : FacebookResponseModel.Picture?
    let id : String?
    let error: FacebookResponseModel.Error?
}

extension FacebookResponseModel {
    
    struct Picture : Codable {
        let data : FacebookResponseModel.Data?
    }


    struct Data : Codable {
        let height : Int?
        let is_silhouette : Bool?
        let url : String?
        let width : Int?
    }
    
    struct FbErrorResponse : Content {
        let error : Error?
    }
    
    struct Error : Content {
        let message : String?
        let type : String?
        let code : Int?
        let fbtrace_id : String?
    }
}

