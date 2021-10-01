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
    app.views.use(.leaf)
    
    
    app.jwt.signers.use(.hs512(key: "mrZTowKXaSvY6QgWHkFxeXXNWnF4ptzQex8COj4zqWnA0dogSR98oCX8/3u/wDj+"))
    app.databases.use(
        .postgres(
            hostname: "localhost",
            port: 4001,
            username: "deploy",
            password: "P@ssword",
            database: "vaporFinder"),
        
        as: .psql)
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRoom())
    try app.autoMigrate().wait()
    try routes(app)
}




extension Application {
    
    static let databaseUrl = URL(string: "postgres://deploy:P@ssword@localhost:40001/finder")!
}
