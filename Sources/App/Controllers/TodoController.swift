import Fluent
import Vapor

struct UserAccountDeleteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let route = routes.grouped("deactivate")
        route.get(use: index)
        
    }

    func index(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.auth.require(User.self)
       return user.$rooms.wrappedValue.map {$0.delete(on: req.db)}.flatten(on: req.db.eventLoop).flatMap({
           return user.delete(on: req.db).map {
                user
            }
        })
    }

  
}
