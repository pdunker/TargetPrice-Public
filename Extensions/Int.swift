//
//  Int.swift
//  TargetPrice
//
//  Created by Philip Dunker on 15/06/24.
//

import Foundation

extension Int {
    
    func formatWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted) T"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted) M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted) K"
        case 0...:
            return String(self)
        default:
            return "\(sign)\(self)"
     
        }
    }
    
}
