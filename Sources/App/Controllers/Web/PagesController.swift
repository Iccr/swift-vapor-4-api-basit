//
//  File.swift
//  
//
//  Created by ccr on 09/12/2021.
//

import Vapor
import FluentKit

enum Lang: String
{
    case eng, nep
}

class PagesController: RouteCollection {
    
    enum Pages: String {
        case privacy, terms, faq, about
    }
  
    
    struct PagesContext: Content {
        var title: String
        var content: String
    }
    
    
    struct PagesQuery {
        var lang: String
    }
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("static", ":name", use: pages)
    }
    
    
    func pages(req: Request) throws -> EventLoopFuture<View> {
        let _lang = try req.query.get(at: "lang") ?? "eng"
        let lang = Lang(rawValue: _lang) ?? .eng
        
        guard let _name = req.parameters.get("name"), let name = Pages(rawValue: _name)  else {
            throw Abort(.notFound)
        }
        
        return try getPage(db: req.db, name: name).flatMap({ pages in
            return req.view.render("static/appPages", self.getContext(name: name, content: pages, lang: lang))
        })
    }
    
    
    func getPage(db: Database, name: Pages) throws -> EventLoopFuture<AppPage> {
        AppPage.query(on: db).filter(\.$name == name.rawValue).first().unwrap(or: Abort(.notFound))
    }
    
    func getContext(name: Pages, content: AppPage, lang: Lang  ) -> PagesContext {
        var context: PagesContext
        switch name {
            case .privacy:
                context =    PagesContext(
                    title: "Privacy Policy",
                    content: lang ==  .nep ? content.nep ?? "" : content.eng ?? ""
                )
            case .terms:
                context =  PagesContext(
                    title: "Terms And Conditions",
                    content: lang ==  .nep ? content.nep ?? "" : content.eng ?? ""
                )
            case .faq:
                context =  PagesContext(
                    title: "FAQ'S",
                    content: lang ==  .nep ? content.nep  ?? "" : content.eng ?? ""
                )
            case .about:
                
                context =  PagesContext(
                    title: "About Us",
                    content: lang ==  .nep ? content.nep ?? ""  : content.eng ?? ""
                )
        }
        return context
    }
}



