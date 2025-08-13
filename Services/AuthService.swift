//
//  AuthService.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    init() {
        Task {
            try await hasOpenUserSession()
        }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await hasOpenUserSession()
            return ""
        } catch {
            print("DEBUG: Failed to login user with error:", error)
            let errorCode = (error as NSError).code
            if errorCode == 17008 {
                return "E-mail está mal formatado."
            } else if errorCode == 17009 {
                return "Preencha a senha."
            } else if errorCode == 17004 {
                return "E-mail e senha não encontrados."
            }
            return error.localizedDescription
        }
    }
    
    @MainActor
    func registerUser(username: String, email: String, password: String) async throws -> String {
        var result = ""
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            try await changeRequest?.commitChanges()
            //try await Auth.auth().currentUser?.sendEmailVerification()
            
            self.userSession = result.user
            
            await createUserData(uid: result.user.uid, username: username, email: email)
            
        } catch {
            print("DEBUG: Failed to register user with error \(error )")
            let errorCode = (error as NSError).code
            if errorCode == 17008 {
                result = "E-mail está mal formatado."
            } else if errorCode == 17009 {
                result = "Preencha a senha."
            } else if errorCode == 17026 {
                result = "A senha tem que ter no mínimo 6 digitos."
            } else if errorCode == 17034 {
                result = "Um e-mail precisa ser fornecido."
            } else {
                result = error.localizedDescription
            }
        }
        return result
    }
    
    func reloadUserSession() {
        self.userSession?.reload(completion: {_ in
            self.userSession = self.userSession
        })
    }
    
    @MainActor
    func hasOpenUserSession() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = self.userSession?.uid else {
            print("DEBUG: no UserSession.")
            return
        }
        self.currentUser = try await UserService.fetchUser(withUid: currentUid)
        print("DEBUG: Logged as \(self.currentUser!.email)")//, with assets: \(self.currentUser!.assetsNames).")
    }
    
    @MainActor
    func logout() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    @MainActor
    func deleteAccount(_ resultCb: @escaping (String) async -> ()) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            var errorMessage = ""
            if let error = error {
                print("DEBUG: Auth.auth() error deleting account:", error)
                let errorCode = (error as NSError).code
                if errorCode == 17014 {
                    errorMessage = "Isso é um operação que não pode ser revertida. Deslogue, logue novamente e repita a operação, por favor."
                } else {
                    errorMessage = error.localizedDescription
                }
            } else {
                print("DEBUG: Auth.auth() account deleted.")
            }
            
            Task {
                await resultCb(errorMessage)
            }
        }
    }
    
    @MainActor
    private func createUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        self.currentUser = user
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {
            print("DEBUG: Failed do encode user:", user)
            return
        }
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
    
    @MainActor
    func updateUserData(user: User) async {
        do {
            let encodedUser = try Firestore.Encoder().encode(user)
            //print("DEBUG: encodedUser:", encodedUser)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("DEBUG: Failed to update user data with error \(error.localizedDescription )")
        }
    }
    
}
