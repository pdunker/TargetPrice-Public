//
//  User.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import Foundation
import Firebase

struct User: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    let email: String
    var assetsNames = [String]()
    var fcmToken = ""
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "user1", email: "user1@gmail"),
    ]
}
