//
//  AlarmService.swift
//  TargetPrice
//
//  Created by Philip Dunker on 10/06/24.
//

import Foundation
import Firebase

class AlarmService {

    static let shared = AlarmService()
    
    func deleteAlarm(alarmId: String) {
        Firestore.firestore().collection("alarms").document(alarmId).delete()
    }
    
    func fetchAlarms(userId: String) async -> [Alarm] {
        //print("DEBUG: AlarmService.fecthAlarms()")
        let alarms_collection = Firestore.firestore().collection("alarms")
        do {
            let snapshot = try await alarms_collection.whereField("ownerId", isEqualTo: userId).getDocuments()
            let alarms = try snapshot.documents.compactMap({ try $0.data(as: Alarm.self )})
            return alarms
        } catch {
            print("DEBUG: Error fetching alarms: \(error.localizedDescription)")
        }
        return []
    }
    
    func addAlarm(asset: Asset, priceTxt: String, sendNotif: Bool, sendEmail: Bool) -> Alarm? {
        guard let user = AuthService.shared.currentUser else {
            print("DEBUG: No user authenticated.")
            return nil
        }
        let aux = priceTxt.replacingOccurrences(of: ",", with: ".")
        guard let targetPrice = Double(aux) else {
            print("DEBUG: Couldn't parse tragetPrice entered: ", priceTxt)
            return nil
        }
        let isBelow = targetPrice < asset.price ? true : false
        
        let alarmRef = Firestore.firestore().collection("alarms").document()
        
        let alarm = Alarm(id: alarmRef.documentID,
                          ownerId: user.id,
                          assetName: asset.name,
                          targetPrice: targetPrice,
                          targetPriceBelow: isBelow,
                          createdAt: Timestamp(),
                          sendNotification: sendNotif,
                          sendEmail: sendEmail)
        guard let encodedAlarm = try? Firestore.Encoder().encode(alarm) else {
            print("DEBUG: Failed to encode alarm:", alarm)
            return nil
        }
     
        Firestore.firestore().collection("alarms").document(alarm.id).setData(encodedAlarm)
        
        return alarm
    }
}
