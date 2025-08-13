//
//  UserService.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import Foundation
import Firebase

struct UserService {
    
    //  static func fetchAllUsers() async throws -> [User] {
    //    let snapshots = try await Firestore.firestore().collection("users").getDocuments()
    //    return snapshots.documents.compactMap({ try? $0.data(as: User.self) })
    //  }
    
    static func fetchUser(withUid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(withUid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func deleteAccount(withUid: String) async throws {
        try await Firestore.firestore().collection("users").document(withUid).delete()
    }
}
