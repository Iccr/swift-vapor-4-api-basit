import Fluent
import Vapor

struct Todos: Content {
    var title: String
    
}

func routes(_ app: Application) throws {
    let protected = app.grouped(UserAuthenticator())
        .grouped(User.guardMiddleware())
    
    // protected
 
    protected.post("rooms") { req in
        return try RoomController().create(req: req)
    }
    
    
    
    // Free
    
    app.get("rooms") { req in
        return try RoomController().index(req: req)
    }
    
    
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    app.post("login") {req -> EventLoopFuture<User>  in
        return try LoginController().create(req: req)
    }
   
    
    app.get("cities") { req in
        return try CityController().index(req: req)
    }
    
    app.get("banners") { req in
        return try BannerController().index(req: req)
    }
    
  
    
    
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

