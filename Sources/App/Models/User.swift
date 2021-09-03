//
//  File.swift
//  
//
//  Created by ccr on 03/09/2021.
//


import Fluent
import Vapor



final class UserContainer : Codable {
    let user : User?

    enum CodingKeys: String, CodingKey {

        case user = "user"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }

}




final class User : Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email : String?
    
    @Field(key: "imageurl")
    var imageurl : String?
    
    @Field(key: "name")
    var name : String?
    
    @Field(key: "token")
    var token : String?
    
    @Field(key: "user_id")
    var user_id : String?
    
    @Field(key: "provider")
    var provider : String?
    

    init() { }
    
    init(id: UUID?, email: String, imageurl: String, name : String?, token : String?, provider : String? ) {
        self.id = id

        self.imageurl = imageurl
        self.name = name
        self.token = token
        self.provider = provider
    }
    
}

//
//defmodule Finder.Accounts.User do
//  use Ecto.Schema
//  import Ecto.Changeset
//
//  @attrs ~w(email imageurl name provider fuid fcm)a
//  @required ~w(provider fcm)a
//
//  schema "users" do
//    field :email, :string
//    field :imageurl, :string
//    field :name, :string
//    field :token, :string
//    field :provider, :string
//    field :auth_token, :string, virtual: true
//    field :fuid, :string
//    field :fcm, :string
//    has_many :rooms, Finder.Rooms.Room
//
//    has_many :sender_conversations, Finder.Chats.Conversation, foreign_key: :sender_id
//    has_many :recipient_conversations, Finder.Chats.Conversation, foreign_key: :recipient_id
//    has_many :messages, Finder.Chats.Messages, foreign_key: :sender_id
//    timestamps()
//  end
//
//  @doc false
//  def changeset(user, attrs) do
//    user
//    |> cast(attrs, @attrs)
//    |> validate_required(@required)
//    |> unique_constraint(:email)
//  end
//end
