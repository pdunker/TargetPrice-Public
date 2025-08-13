//
//  DatabaseService.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import Combine
import FirebaseDatabase

class DatabaseService {
    
    static let shared = DatabaseService()
    
    @Published var assets = [Asset]()
    
    private let ref = Database.database().reference()
    
//    func fetchAssets(assetsNames: [String]) {
//        for assetName in assetsNames {
//            AssetService.shared.fetchAsset(assetName)
//        }
//    }
//
//    func addAsset(_ name: String, _ asset_data: NSDictionary) {
//        let time = asset_data["time"] as! String
//        self.assets.append(Asset(id: NSUUID().uuidString,
//                                 name: name,
//                                 open: asset_data["open"] as! Double,
//                                 high: asset_data["high"] as! Double,
//                                 low: asset_data["low"] as! Double,
//                                 price: asset_data["price"] as! Double,
//                                 variation: asset_data["variation"] as! Double,
//                                 volume: asset_data["volume"] as? Int ?? 0,
//                                 currency: asset_data["currency"] as! String,
//                                 country: asset_data["country"] as! String,
//                                 updated: Date(updateDateString: time)))
//    }
//
//    func fetchAsset(_ assetName: String) {
//        ref.child("assets/" + assetName).observeSingleEvent(of: .value) { snapshot in
//            if let data = snapshot.value as? NSDictionary {
//                self.addAsset(assetName, data)
//            }
//        }
//    }
    
    func addFeedback(_ message: String) {
        let username = AuthService.shared.currentUser!.username
        let email = AuthService.shared.currentUser!.email
        let id = NSUUID().uuidString
        let timestamp = FirebaseDatabase.ServerTimestamp(wrappedValue: .now)
        let message = [
            "username": username,
            "email": email,
            "message": message,
            "timestamp": timestamp.wrappedValue?.fullDateString(),
        ]

        //reason: '(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']''
        let key = username
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "#", with: "_")
            .replacingOccurrences(of: "$", with: "_")
            .replacingOccurrences(of: "[", with: "_")
            .replacingOccurrences(of: "]", with: "_")
        ref.child("messages/"+key+"/"+id).setValue(message)

    }
    
    func fetchAllAssets() {
        print("DEBUG: AssetService.fetchAllAssets()")
        
        self.assets.removeAll()
        
        ref.child("assets").observeSingleEvent(of: .value) { snapshot, arg in
            if let data = snapshot.value as? NSDictionary {
                self.parseAssets(data)
            } else {
                print("DEBUG: Error converting data to NSDictionary: ", snapshot.value!)
            }
        }
        
    }
    
    func parseAssets(_ assets_data: NSDictionary) {
        var assets = [Asset]()
        for assetName in assets_data.allKeys {
            let ticker = assetName as? String ?? ""
            if ticker == "EURUSD" || ticker == "" {
                continue
            }
            let asset_data = assets_data[ticker] as! NSDictionary
            
            let time = asset_data["time"] as! String
            var currency = asset_data["currency"] as? String ?? "$"
            if currency == "USD" {
                currency = "US$"
            } else if currency == "BRL" {
                currency = "R$"
            }
            let sector = asset_data["sector"] as? String ?? ""
            var fullname = asset_data["name"] as? String ?? ""
            fullname = fullname.trimmingCharacters(in: .whitespacesAndNewlines)
            assets.append(Asset(id: NSUUID().uuidString,
                                name: ticker,
                                fullname: fullname,
                                open: asset_data["open"] as? Double ?? -1,
                                high: asset_data["high"] as? Double ?? -1,
                                low: asset_data["low"] as? Double ?? -1,
                                price: asset_data["price"] as? Double ?? -1,
                                variation: asset_data["variation"] as? Double ?? 0,
                                volume: asset_data["volume"] as? Int ?? -1,
                                currency: currency,
                                country: asset_data["country"] as? String ?? "",
                                sector: sector,
                                updated: Date(updateDateString: time)))
        }
        self.assets = assets
    }
    
    
    func fetchAllBonds() {
        print("DEBUG: AssetService.fetchAllBonds()")
        
        //self.assets.removeAll()
        
        ref.child("treasures").observeSingleEvent(of: .value) { snapshot, arg in
            if let data = snapshot.value as? NSDictionary {
                print("DEBUG: data: ", data)
            } else {
                print("DEBUG: Error converting data to NSDictionary: ", snapshot.value!)
            }
        }
        
    }
}
