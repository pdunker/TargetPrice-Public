//
//  Double.swift
//  TargetPrice
//
//  Created by Philip Dunker on 26/05/24.
//

import Foundation

extension Double {
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toCurrency() -> String {
        return currencyFormatter.string(for: self) ?? " 0.00"
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toPercentString() -> String {
        var plusSign = ""
        if self > 0 {
            plusSign = "+"
        }
        //return plusSign + (numberFormatter.string(for: self) ?? "0.00") + "%"
        return plusSign + self.asNumberString() + "%"
    }
    
    func asNumberString(_ digits: Int = 2) -> String {
        let digitsStr = String(digits)
        let format = "%." + digitsStr + "f"
        return String(format: format, self)
    }
    
}
