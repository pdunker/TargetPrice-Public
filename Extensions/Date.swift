//
//  Date.swift
//  TargetPrice
//
//  Created by Philip Dunker on 28/05/24.
//

import Foundation


extension Date {
    
    //  init(coinGeckoString: String) {
    //    let formatter = DateFormatter()
    //    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //    let date = formatter.date(from: coinGeckoString) ?? Date()
    //    self.init(timeInterval: 0, since: date)
    //  }
    init(updateDateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        let convertedDate = formatter.date(from: updateDateString)
        if convertedDate != nil {
            self.init(timeInterval: 0, since: convertedDate!)
        } else {
            print("DEBUG: Couldn't convert date:", updateDateString)
            self.init(timeIntervalSince1970: 0)
        }
    }
    
    private var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        return formatter
    }
    func fullDateString() -> String {
        return fullDateFormatter.string(from: self)
    }
    
    private var dateNoYearNoSecsFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }
    func dateNoYearNoSecString() -> String {
        return dateNoYearNoSecsFormatter.string(from: self)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
    func dateString() -> String {
        return dateFormatter.string(from: self)
    }
    
    
    private var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
    func shortDateString() -> String {
        return shortDateFormatter.string(from: self)
    }
    
    private var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd  HH:mm"
        return formatter
    }
    func mediumDateString() -> String {
        return mediumDateFormatter.string(from: self)
    }
}
