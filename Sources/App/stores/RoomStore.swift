//
//  File.swift
//  
//
//  Created by ccr on 07/10/2021.
//

import Foundation
import Vapor
import Fluent

class RoomStore {
    func getAllRooms(_ searchQuery: Room.Querry, req: Request) -> EventLoopFuture<Page<Room.Output>> {
        let query =  Room.query(on: req.db)
        
        return self.querries(query: query, params: searchQuery)
            .with(\.$city)
            .with(\.$user)
            .paginate(for: req).map { page in
                page.map { $0.responseFrom(baseUrl: req.baseUrl)
                }
            }
    }
    
    func create(req: Request, room: Room, input: Room.Entity, user: User ) throws ->  EventLoopFuture<Room.Output> {
        let uploadPath = req.application.directory.publicDirectory + "uploads/"
        
        return input.images.map { file -> EventLoopFuture<String> in
            if file.filename.isEmpty {
                return req.eventLoop.future("")
            }
            let filename = "\(Date().timeIntervalSince1970)_" + file.filename.replacingOccurrences(of: " ", with: "")
            req.logger.log(level: .critical, "\(filename): about to write to disk")
            return req.fileio.writeFile(file.data, at: uploadPath + filename ).map {
                req.logger.log(level: .critical, "\(filename): wrotei to disk")
                return filename
                
            }
        }.flatten(on: req.eventLoop).map { filenames in
            room.vimages = filenames
        }.flatMap { _ in
            return City.query(on: req.db)
                .filter(\.$id == input.city_id)
                .first()
        }.flatMap { city in
            room.$user.id = user.id ?? -1
            room.$city.id = city?.id ?? -1
            return room.create(on: req.db).map {
                return room.responseFrom(baseUrl: req.baseUrl)
            }
        }
    }
    
    func getWithId(req: Request) throws -> EventLoopFuture<Room.Output> {
        if let _id = req.parameters.get("id"), let id = Int(_id) {
            return Room.find(id, on: req.db).flatMapThrowing { room in
                if let room = room {
                    return room.responseFrom(baseUrl: req.baseUrl)
                }
                throw Abort(.notFound)
            }
        }
        throw Abort(.notFound)
    }
    
    func getMyRooms(req: Request, user: User) -> EventLoopFuture<[Room.Output]> {
        return user.$rooms.get(on: req.db).mapEach {$0.responseFrom(baseUrl: req.baseUrl)}
    }
    
    func update(req: Request, input: Room.Update) throws -> EventLoopFuture<Room.Output> {
        return Room.find(input.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { room in
                return room.get(update: input).update(on: req.db).map {
                    room.responseFrom(baseUrl: req.baseUrl)
                }
            }
    }
    
    func showMyRooms(req: Request) throws -> EventLoopFuture<[Room.Output]> {
        let user = req.auth.get(User.self)
        return User.find(user?.id, on: req.db).unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$rooms.load(on: req.db).map {
                    return user.rooms.map({$0.responseFrom(baseUrl: req.baseUrl)})
//                    return req.view.render("myroom", ["items": result])
                }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Room.Output> {
        let uploadPath = req.application.directory.publicDirectory + "uploads/"
        let toDelete = try req.query.decode(Room.Input.self)

        return Room.find(toDelete.id, on: req.db).unwrap(or: Abort(.badRequest))
            .flatMap { room in
                room.vimages.forEach({ filename in
                    let path = uploadPath + filename
                    let manager = FileManager.default
                    
                    if manager.fileExists(atPath: path ) {
                        if let url: URL = .init(string: path) {
                            try? manager.removeItem(at: url)
                        }

                    }
                })
                
                return room.delete(on: req.db).map {
                    return room.responseFrom(baseUrl: req.baseUrl)
                }
            }
//        return Room.find(user?.id, on: req.db).unwrap(or: Abort(.notFound))
//            .flatMapThrowing { room in
//
//                try room.vimages.forEach { filename in
//                    let path = uploadPath + filename
//                    let manager = FileManager.default
//                    if manager.fileExists(atPath: path ) {
//                        if let url: URL = .init(string: path) {
//                            try manager.removeItem(at: url)
//                        }
//
//                    }
//                }
//
//                return room.delete(on: req.db).map {
//                    return room.responseFrom(baseUrl: req.ba)
//                }
//            }
    }
    
//    if let room  = room {
//        room.occupied = input.occupied
//        return room.update(on: req.db).map {
//         return room.responseFrom(baseUrl: req.baseUrl)
//       }
//    }
//    throw Abort(.notFound)
    
}


extension RoomStore {
//    Planet.query(on: database)
//        .join(Star.self, on: \Planet.$star.$id == \Star.$id)
//        .filter(Star.self, \.$name == "Sun")
//        .all()
    
    func querries(query: QueryBuilder<Room>, params: Room.Querry) -> QueryBuilder<Room> {
        if let val = params.city, !val.isEmpty {
            query.filter(.sql(raw: "LOWER(city_name) ILIKE '%\(val)%'"))
        }
        
        if  !params.type.isEmpty {
            query.filter(\.$type ~~ params.type)
        }
        if let val = params.kitchen {
            query.filter(\.$kitchen == val)
        }
        if let val = params.floor, val != "any" {
//            query.filter(\.$floor == val)
            query.filter(.sql(raw: "LOWER(floor) ILIKE '%\(val)%'"))
        }
        
        if let val = params.address {
            query.filter(\.$address ~= val)
        }
        
        if let val = params.district {
            query.filter(\.$district ~= val)
        }
        
        if let val = params.state {
            query.filter(\.$state ~= val)
        }
        
        if let val = params.localGov {
            query.filter(\.$localGov ~= val)
        }
        
        if  !params.parking.isEmpty {
            query.filter(\.$parking ~~ params.parking)
        }
        
//        if let val = params.parking {
//            query.filter(\.$parking ~~ val)
//        }
        
        if let val = params.water {
            query.filter(.sql(raw: "LOWER(water) ILIKE '%\(val)%'"))
//            query.filter(\.$water ~~ val)
        }
        
        if let val = params.internet {
            query.filter(.sql(raw: "LOWER(internet) ILIKE '%\(val)%'"))
//            query.filter(\.$internet ~~ val)
        }
        
        if let val = params.preference {
            query.filter(.sql(raw: "LOWER(preference) ILIKE '%\(val)%'"))
//            query.filter(\.$preference ~~ val)
        }
        
        
        if let val = params.lowerPrice {
            query.filter(\.$price >= val)
        }
        
        if let val = params.upperPrice {
            query.filter(\.$price <= val)
        }
        
        if let val = params.price {
            if val == "low-to-high" {
                query.sort(\.$price, .ascending)
            }else {
                 query.sort(\.$price, .descending)
            }
        }
        return query
    }
}
