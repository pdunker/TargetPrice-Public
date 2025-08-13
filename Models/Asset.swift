//
//  Asset.swift
//  TargetPrice
//
//  Created by Philip Dunker on 12/06/24.
//

import SwiftUI

struct Asset: Identifiable {
    let id: String // uuid
    let name, fullname: String // symbol name
    let open, high, low, price: Double
    let variation: Double// (percentage)
    let volume: Int
    let currency: String
    let country: String
    let sector: String
    let updated: Date // "YYYY-MM-DD hh:mm"
    let digits: Int
    
    var nameWidth: CGFloat {
        return self.name.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width
    }
    
    var variationColor: Color {
        if variation == 0 {
            return .gray
        } else if variation > 0 {
            return .green
        } else {
            return .red
        }
    }
    
    init(id: String, name: String, fullname: String, open: Double, high: Double, low: Double, price: Double, variation: Double, volume: Int, currency: String, country: String, sector: String, updated: Date, digits: Int = 2) {
        self.id = id
        self.name = name
        self.fullname = fullname
        self.open = open
        self.high = high
        self.low = low
        self.price = price
        self.variation = variation
        self.volume = volume
        self.currency = currency
        self.country = country
        self.sector = sector
        self.updated = updated
        self.digits = Asset.getDigitsCount(name)
    }
}


extension Asset {

    static var SectorCrypto = "Crypto Currency"
    
    static func getDigitsCount(_ assetName: String) -> Int {
        var digits = 2 // default
        if ["BTCUSD", "IND"].contains(assetName) {
            digits = 0
        } else if ["DOL"].contains(assetName) {
            digits = 1
        } else if ["DOGEUSD", "XRPUSD", "ADAUSD"].contains(assetName) {
            digits = 4
        }
        return digits
    }
    
    static var NVDA = Asset(id: NSUUID().uuidString,
                            name: "NVDA",
                            fullname: "NVIDIA Corporation",
                            open: 170.09,
                            high: 199.99,
                            low: 169.01,
                            price: 185.56,
                            variation: 1.25,
                            volume: 0,
                            currency: "US$",
                            country: "USA",
                            sector: "Technology",
                            updated: Date(updateDateString: "2024-06-13 14:50"))
    
    static var VALE = Asset(id: NSUUID().uuidString,
                            name: "VALE3",
                            fullname: "VALE        ON      NM",
                            open: 62.82,
                            high: 63.95,
                            low: 62.80,
                            price: 60.62,
                            variation: -0.35,
                            volume: 987654321,
                            currency: "R$",
                            country: "BR",
                            sector: "",
                            updated: Date(updateDateString: "2024-06-15 14:50"))
}
