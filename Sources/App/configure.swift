import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    app.routes.defaultMaxBodySize = "10mb"
    app.logger.logLevel = .debug
    app.views.use(.leaf)
    
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(file)
    app.jwt.signers.use(.hs512(key: Env.jwtSecret))
    app.databases.use(
        .postgres(
            hostname: Env.hostname,
            port: Env.port,
            username: Env.username,
            password: Env.password,
            database: Env.database),
        
        as: .psql)
//    app.migrations.add(CreateUser())
    app.migrations.add(CreateCity())
    app.migrations.add(CreateRoom())
    
    try seed(app.db)
    try app.autoMigrate().wait()
    try routes(app)
}

func seed(_ db: Database) throws {
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
    
    _ = try kathmandu.create(on: db).and(pokhara.create(on: db)).wait()
    
}
