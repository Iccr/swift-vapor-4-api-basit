//
//  File.swift
//  File
//
//  Created by ccr on 17/11/2021.
//

import Foundation
import Vapor
class AdminDashboardStore {
  
    
    func dashboard(req: Request, user: User)  -> EventLoopFuture<AdminDashboardContext> {
        let combined =  getAllPropertyCount(req: req)
            .and(getActivePropertyCount(req: req))
            .and(getCityCount(req: req))
            .and(getUserCount(req: req))
        
        return combined.map { (value: (((apc: Int, pc: Int), cc: Int), uc: Int)) in
            return AdminDashboardContext(
                            name: user.name ?? user.email ?? "",
                            image: user.image ?? "/admin/dist/img/user2-160x160.jpg",
                            propertyCount: value.0.0.pc,
                            activePropertyCount: value.0.0.apc,
                            userCount: value.uc,
                            cityCount: value.0.cc
                        )
        }
    }
    
    private func getActivePropertyCount(req: Request) -> EventLoopFuture<Int> {
        return Room.query(on: req.db).filter(\.$occupied, .equal, false).count()
    }
    
    private func getAllPropertyCount(req: Request) -> EventLoopFuture<Int> {
        return Room.query(on: req.db).count()
    }
    
    
    private func getCityCount(req: Request) -> EventLoopFuture<Int> {
        return City.query(on: req.db).count()
    }
    
    private func getUserCount(req: Request) -> EventLoopFuture<Int> {
        return User.query(on: req.db).count()
    }
    
}


extension AdminDashboardStore {
    struct AdminDashboardContext: Content {
        var name: String
        var image: String
        var propertyCount: Int
        var activePropertyCount: Int
        var userCount: Int
        var cityCount: Int
    }
}
