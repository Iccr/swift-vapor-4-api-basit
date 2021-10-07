import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import JWT

import Foundation
// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    
    app.logger.logLevel = .debug
    app.views.use(.leaf)
    
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)

    app.middleware = .init()
    app.middleware.use(MyErrorMiddleware())
    
    app.middleware.use(file)
    app.routes.defaultMaxBodySize = "10mb"
    app.jwt.signers.use(.hs256(key: Env.jwtSecret))
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    var port: Int = 5433
    if let _p = Environment.get("DATABASE_PORT"), let _port = Int(_p) {
        port = _port
    }
    let username = Environment.get("DATABASE_USERNAME") ?? "ccr"
    let dbName = Environment.get("DATABASE_NAME") ?? "vfinder"
    let dbPassword = Environment.get("DATABASE_PASSWORD") ?? "password"
    print("connecting")
          
    print(hostname + ":" + "\(port)" + " " + username + " " + dbPassword + " " + dbName)

    
    app.databases.use(
        .postgres(
            hostname: hostname,
            port: port,
            username: username,
            password: dbPassword,
            database: dbName),
        as: .psql)
    
    print("migrating")
    app.migrations.add(CreateUser())
    app.migrations.add(TokenMigration())
    app.migrations.add(CreateCity())
    app.migrations.add(CreateRoom())
    app.migrations.add(CreateBanner())
    
    seed(app.db)
    try app.autoMigrate().wait()
    try routes(app)
}

func seed(_ db: Database)  {
    let kathmandu = City(
        name: "Kathmandu",
        image: "/samples/kathmandu.jpg",
        description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
    )
    
    let pokhara = City(
        name: "Pokhara",
        image: "/samples/kathmandu.jpg",
        description: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
    )
    
   
    
    _ = db.query(City.self).count()
        .flatMapThrowing { count in
        if count == 0 {
            _ =   [kathmandu, pokhara].create(on: db)
        }
    }
    
    
    // banner
    
    let b1 = Banner( title: "Start Earning", image: "/samples/kathmandu.jpg", subtitle: "List a place", type: "property", value: "1")
    
    let b2 = Banner( title: "Monetary Parntership", image: "/samples/kathmandu.jpg", subtitle: "List second place", type: "property", value: "2")
    
    _ = db.query(Banner.self).count()
        .flatMapThrowing { count in
        if count == 0 {
            _ =   [b1, b2].create(on: db)
        }
    }
     
}


class MyErrorMiddleware: Middleware {
    internal struct ErrorResponse: Codable {
        /// Always `true` to indicate this is a non-typical JSON response.
        /// The reason for the error.
        var message: String
    }
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        
        return next.respond(to: request).flatMapErrorThrowing { error in
            var reason: String
            var status: HTTPResponseStatus
            var headers: HTTPHeaders
            switch error {
                case let abort as AbortError:
                    // this is an abort error, we should use its status, reason, and headers
                    reason = abort.reason
                    status = abort.status
                    headers = abort.headers
            
                default:
                    // not an abort error, and not debuggable or in dev mode
                    // just deliver a generic 500 to avoid exposing any sensitive error info
                    reason = "Something went wrong."
                    status = .internalServerError
                    headers = [:]
//                    source = nil
            }
            
            let response = Response(status: status, headers: headers)
            
            let errorResponse = ErrorResponse( message: reason)
//            json = try JSONEncoder().encode(["error": result.message])
            response.body = try .init(data: JSONEncoder().encode(["error": errorResponse] ))
            response.headers.add(name: .contentType, value: "application/json")
            return response
            
        }
    }
}

