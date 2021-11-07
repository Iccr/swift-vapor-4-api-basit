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
        guard let error = ctx.data["alert"]?.string else {
            return LeafData.string(nil)
        }
 
        let level = ctx.data["alertLevel"] ?? 1
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
                        \(error)
                    </div>
                """
        )}
}

