import Fluent
import Vapor

struct Todos: Content {
    var title: String
    
}

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.post("todos") { req -> HTTPResponseStatus in
        let greeting = try req.content.decode(Todos.self)
        print(greeting.title) // "world"
        return HTTPStatus.ok
    }
    
    app.post("login") {req -> EventLoopFuture<User>  in
        return try LoginController().create(req: req)
    }
    
//    http://{{baseurl}}/api/v1/login
    
}



//
//{
//    "user":  {
//      "email" : "asdfa",
//      "imageurl" : "some updated imageurl",
//      "name" : "some updated name",
//      "token": "s1IsooBADAXl4cMls6OFMC71v4f2GqFlfuZCRg8JZCn9uYOmolZBT6Abhxqf4L9kU144R8ZCwMMRssIsyXD43YAAqvVtcUPQBedO4ocdLunTZBLlZB913N5KNyGdqMNASkqwUoGF0PeWEXZClc2ztn91tKOPrRhkf84DQZCtZCJAtuJERUecMBC3ULIevX3v2ELZAjERp82M8V7jNGHCRWchKgBq0A93dUbzoyhqJtZBzXZCf401XII",
//      "user_id": "3029953507070886",
//      "provider": "google"
//    }
//}

