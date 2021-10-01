//
//  File.swift
//  
//
//  Created by ccr on 01/10/2021.
//

import Foundation
import Fluent
import Vapor

struct RoomController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
//        let todos = routes.grouped("todos")
//        todos.get(use: index)
//        todos.post(use: create)
//
//        todos.group(":todoID") { todo in
//            todo.delete(use: delete)
//        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Room]> {
        return Room.query(on: req.db).all()
    }

//    func create(req: Request) throws -> EventLoopFuture<Todo> {
//        print(req.body)
//        print(req.content)
//        print(req.method)
//        print(req.parameters)
//        let todo = try req.content.decode(Todo.self)
//        print(todo.title)
//        return todo.save(on: req.db).map { todo }
//    }
//
//    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        return Todo.find(req.parameters.get("todoID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { $0.delete(on: req.db) }
//            .transform(to: .ok)
//    }
}
