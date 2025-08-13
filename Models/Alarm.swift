//
//  Alarm.swift
//  TargetPrice
//
//  Created by Philip Dunker on 09/06/24.
//

import Foundation
import Firebase

struct Alarm: Identifiable, Hashable, Codable {
    let id: String
    var ownerId: String
    
    var assetName: String
    var targetPrice: Double
    var targetPriceBelow: Bool
    var createdAt: Timestamp
    
    var sendNotification: Bool = true
    var sendEmail: Bool = true
    
    var rang: Bool = false
    var rangAt: Timestamp?
}

extension Alarm {
    static var Mock: Alarm = .init(id: NSUUID().uuidString,
                                   ownerId: NSUUID().uuidString,
                                   assetName: "TSLA",
                                   targetPrice: 190,
                                   targetPriceBelow: false,
                                   createdAt: Timestamp())
    
}
