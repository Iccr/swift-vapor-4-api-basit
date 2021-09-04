import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    app.logger.logLevel = .trace
    app.jwt.signers.use(.hs256(key: "secret"))
    app.databases.use(
        .postgres(
            hostname: "localhost",
            port: 4001,
            username: "deploy",
            password: "P@ssword",
            database: "finder"),
        
        as: .psql)

//    app.databases.use(try .postgres(url: Application.databaseUrl), as: .psql)
    app.migrations.add(CreateUser())

    try routes(app)
}




extension Application {
    
    static let databaseUrl = URL(string: "postgres://deploy:P@ssword@localhost:40001/finder")!
}
