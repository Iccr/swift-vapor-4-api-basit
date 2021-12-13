import Vapor
import Fluent

class PageStore {
    
    func getAllPages(req: Request) throws -> EventLoopFuture<[AppPage]> {
        return AppPage.query(on: req.db).all()
//        return City.query(on: req.db).with(\.$rooms).sort(\.$createdAt, .ascending).all()
    }
    
    func update(req: Request) throws -> EventLoopFuture<AppPage> {
        let toUpdate = try req.content.decode(AppPage.Input.self)
        return try self.find(toUpdate.id, req: req)
            .unwrap(or: Abort(.badRequest))
            .flatMap { pages in
                pages.name = toUpdate.name
                pages.eng = toUpdate.eng ?? pages.eng
                pages.nep = toUpdate.nep ?? pages.nep

                return pages.update(on: req.db).map {
                    return pages
                }
            }
    }
    
    func find(_ id: Int?, req: Request) throws -> EventLoopFuture<AppPage?> {
        return AppPage.find(id, on: req.db)
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Void> {
        let toDelete = try req.content.decode(AppPage.IDInput.self)
        return AppPage.query(on: req.db)
            .filter(\.$id == toDelete.id)
            .delete()
    }
}
