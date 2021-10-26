import Fluent

extension User {
    struct CreateUserMigration: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("users")
                .field("id", .int, .identifier(auto: true))
                .field("email", .string)
                .field("imageurl", .string)
                .field("name", .string)
                .field("token", .string)
                .field("appleUserIdentifier", .string)
                .field("fcm", .string)
                //            .field("user_id", .int, .required)
                .field("provider", .string, .required)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("users").delete()
        }
    }
    
    struct AddRoleToUser: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("users")
                .field("role", .string ,.sql(.default(User.Role.normalUser.rawValue)))
                .update()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("users")
                .deleteField("role")
                .update()
        }
    }
    
    struct AddStatusToCity: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("cities")
                .field("status", .bool, .sql(.default(false)))
                .update()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema("cities")
                .deleteField("status")
                .update()
        }
    }
}







struct TokenMigration: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema)
            .field("id", .int, .identifier(auto: true))
            .field("userID", .int, .references("users", "id"))
            .field("value", .string, .required)
            .unique(on: "value")
            .field("createdAt", .datetime, .required)
            .field("expiresAt", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema).delete()
    }
}
