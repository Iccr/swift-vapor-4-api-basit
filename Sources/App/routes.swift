import Fluent
import Vapor

struct Todos: Content {
    var title: String
    
}

func routes(_ app: Application) throws {
    let imperialController = ImperialController()
//        try router.register(collection: imperialController)
    
    try app.routes.register(collection: imperialController)
    
    let sessions = app.grouped(app.sessions.middleware)
    
    
    let api = app.grouped("api", "v1")
    
    let protectedApi = api.grouped(UserAuthenticator()).grouped(User.guardMiddleware())
    
    
    // protected
 
    protectedApi.post("rooms") { req in
        return try RoomController().create(req: req)
    }
    
    protectedApi.get("myRooms") {req in
        return try RoomController().getMyRooms(req: req)
    }
    
    protectedApi.patch("rooms") { req in
        return try RoomController().update(req: req)
    }
    
    
    
    // Free
    
    
    api.get("rooms") { req in
        return try RoomController().index(req: req)
    }
    
    api.get("rooms", ":id") { req in
        return try RoomController().show(req: req)
    }
    
    api.post("login") {req  in
        return try LoginController().create(req: req)
    }
   
    
    api.get("cities") { req in
        return try CityController().index(req: req)
    }
    
    api.get("banners") { req in
        return try BannerController().index(req: req)
    }
    
    // web
    
    sessions.get { req in
        try RoomWebController().index(req: req)
    }
    
    sessions.get("login") { req in
         LoginWebController().signIn(req: req)
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

