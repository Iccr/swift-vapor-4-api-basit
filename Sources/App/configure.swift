import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import JWT



import Foundation
// configures your application
public func configure(_ app: Application) throws {

//    app.views.use(.leaf)
    
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
//
//    try routes.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete") { (request, token) in
//        print(token)
//        return request.eventLoop.future(request.redirect(to: "/"))
//    }
    
    
    app.middleware = .init()
    app.middleware.use(MyErrorMiddleware())
    app.views.use(.leaf)
    app.middleware.use(file)
    app.routes.defaultMaxBodySize = "10mb"
    
    #if DEBUG
    let jwtSecret = Environment.get("JWT_SECRET") ?? Env.jwtSecret
    app.logger.logLevel = .debug
    #else
    let jwtSecret = Environment.get("JWT_SECRET") ?? ""
    app.logger.logLevel = .error
    #endif
    
    app.jwt.signers.use(.hs256(key: jwtSecret))
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    var port: Int = 5433
    if let _p = Environment.get("DATABASE_PORT"), let _port = Int(_p) {
        port = _port
    }
    let username = Environment.get("DATABASE_USERNAME") ?? "ccr"
    let dbName = Environment.get("DATABASE_NAME") ?? "vfinder"
    let dbPassword = Environment.get("DATABASE_PASSWORD") ?? "password"
    app.middleware.use(app.sessions.middleware)

    app.databases.use(
        .postgres(
            hostname: hostname,
            port: port,
            username: username,
            password: dbPassword,
            database: dbName,
            maxConnectionsPerEventLoop: 50),
        
        as: .psql)
    
    
    app.migrations.add(User.CreateUserMigration())
    app.migrations.add(TokenMigration())
    app.migrations.add(City.CreateCityMigration())
    app.migrations.add(Room.CreateRoomMigration())
    app.migrations.add(Banner.CreateBannerMigration())
    
    seed(app.db)
    try? app.autoMigrate().wait()
    try routes(app)
    
    app.routes.all.forEach { route in
        print(route)
    }
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






struct CommonResponse<T: Content>: Content {
    let data: T
}



class Apple {
    struct AccessToken {
      static let expirationTime: TimeInterval = 30 * 24 * 60 * 60 // 30 days
    }

    struct SIWA {
      static let applicationIdentifier =  Environment.get("IOS_APP_ID") ?? ""
      static let servicesIdentifier = "SIWA_SERVICES_IDENTIFIER" //e.g. com.raywenderlich.siwa-vapor.services
      static let redirectURL = "SIWA_REDIRECT_URL" // e.g. https://foobar.ngrok.io/web/auth/siwa/callback
    }
}
