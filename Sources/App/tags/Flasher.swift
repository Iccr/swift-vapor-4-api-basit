//
//  File.swift
//  File
//
//  Created by ccr on 07/11/2021.
//



import Foundation
import Leaf


struct FlasherTagError: Error {}

class Flasher: LeafTag, UnsafeUnescapedLeafTag {
    func render(_ ctx: LeafContext) throws -> LeafData {
       
        let message = ctx.data["alert"]?.dictionary?["alert"]?.string
        let level = ctx.data["alert"]?.dictionary?["priority"]?.int ?? 1
        guard let _ = message else {
            return LeafData.string(nil)
        }

        var alertClass = ""
        switch level {
            case 0:
                alertClass = "alert-success"
            case 1:
                alertClass = "alert-info"
            case 2:
                alertClass = "alert-warning"
            case 3:
                alertClass = "alert-danger"
            default:
                alertClass = "alert-info"
                
        }
        
        return LeafData.string(
                """
                    <div id = "veda-falsher" class="alert \(alertClass)" role="alert">
                        \(message ?? "")
                    </div>
                """
        )}
}

