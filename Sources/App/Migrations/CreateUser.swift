import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("email", .string)
            .field("imageurl", .string)
            .field("name", .string)
            .field("token", .string, .required)
            .field("appleUserIdentifier", .string)
//            .field("user_id", .int, .required)
        
            .field("provider", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}

