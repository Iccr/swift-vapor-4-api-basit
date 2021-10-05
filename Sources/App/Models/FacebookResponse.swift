//
//  File.swift
//  
//
//  Created by ccr on 05/10/2021.
//

import Foundation

struct FacebookResponseModel : Codable {
    let name : String?
    let first_name : String?
    let last_name : String?
    let email : String?
    let picture : FacebookResponseModel.Picture?
    let id : String?
    let error: FbErrorResponse?
    
    
    
    enum CodingKeys: String, CodingKey {

        case name = "name"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case picture = "picture"
        case id = "id"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        picture = try values.decodeIfPresent(FacebookResponseModel.Picture.self, forKey: .picture)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        error = try  values.decodeIfPresent(FacebookResponseModel.FbErrorResponse.self, forKey: .error)
    }

}

extension FacebookResponseModel {
    
    struct Picture : Codable {
        let data : FacebookResponseModel.Data?

        enum CodingKeys: String, CodingKey {

            case data = "data"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            data = try values.decodeIfPresent(FacebookResponseModel.Data.self, forKey: .data)
        }

    }


    struct Data : Codable {
        let height : Int?
        let is_silhouette : Bool?
        let url : String?
        let width : Int?

        enum CodingKeys: String, CodingKey {

            case height = "height"
            case is_silhouette = "is_silhouette"
            case url = "url"
            case width = "width"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            height = try values.decodeIfPresent(Int.self, forKey: .height)
            is_silhouette = try values.decodeIfPresent(Bool.self, forKey: .is_silhouette)
            url = try values.decodeIfPresent(String.self, forKey: .url)
            width = try values.decodeIfPresent(Int.self, forKey: .width)
        }

    }
    
    struct FbErrorResponse : Codable {
        let error : Error?

        enum CodingKeys: String, CodingKey {

            case error = "error"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            error = try values.decodeIfPresent(Error.self, forKey: .error)
        }

    }
    
    struct Error : Codable {
        let message : String?
        let type : String?
        let code : Int?
        let fbtrace_id : String?

        enum CodingKeys: String, CodingKey {

            case message = "message"
            case type = "type"
            case code = "code"
            case fbtrace_id = "fbtrace_id"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            message = try values.decodeIfPresent(String.self, forKey: .message)
            type = try values.decodeIfPresent(String.self, forKey: .type)
            code = try values.decodeIfPresent(Int.self, forKey: .code)
            fbtrace_id = try values.decodeIfPresent(String.self, forKey: .fbtrace_id)
        }

    }



}

