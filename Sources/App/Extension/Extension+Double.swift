//
//  File.swift
//  File
//
//  Created by ccr on 16/11/2021.
//

import Foundation



extension Double {
    var toString: String {
        return "\(self)"
    }
}


extension Double {
    func getNumberWithNepaliFormat( precision: Int = 2) -> String? {
        let number = self
        
        if  number != 0 {
            let nsNumber = NSNumber.init(value: number)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = precision
            formatter.usesGroupingSeparator = true
            formatter.groupingSize = 3
            formatter.secondaryGroupingSize = 2
            formatter.maximumFractionDigits = precision
            let result = formatter.string(for: nsNumber)
            return result
        }
        return nil
    }
    
    func getShortCurrency( precision: Int = 2) -> String? {
        let number = self
        
        if  number != 0 {
            if number < 1_000 {
                return "Rs.\(number)"
            }else if number >= 1_000 && number < 10_000 {
                let remainder = number.remainder(dividingBy: 1000)
                return remainder  == 0 ? "1K" : "1.\(remainder)k"
            } else if number >= 10_000 && number < 100_000 {
                let remainder = number.remainder(dividingBy: 10_000)
                return remainder == 0 ? "10K" : "10.\(remainder)k"
            }else if number >= 100_000  {
                let remainder = number.remainder(dividingBy: 100_000)
                return remainder  == 0 ? "100K" : "100.\(remainder)k"
            }
        }
        return nil
    }
}
