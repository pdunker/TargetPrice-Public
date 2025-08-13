//
//  LoginViewModel.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var showAlert = false
    @Published var alertText = ""
    
    @MainActor
    func login() async throws {
        let result = try await AuthService.shared.login(withEmail: email, password: password)
        if result != "" {
            self.alertText = result
            self.showAlert = true
        }
    }
    
    @MainActor
    func registerUser() async throws {
        if self.username == "" {
            self.alertText = "Preencha um nome de usuário."
            self.showAlert = true
            return
        }
        let result = try await AuthService.shared.registerUser(username: username, email: email, password: password)
        if result != "" {
            self.alertText = result
            self.showAlert = true
        } else {
            self.username = ""
            self.email = ""
            self.password = ""
        }
    }
    
    @MainActor
    func forgotPassword() async throws {
        if self.email == "" {
            self.alertText = "Preencha seu e-mail."
        } else {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: self.email)
                self.alertText = "Foi enviado um e-mail para criar uma nova senha."
            } catch {
                let errorCode = (error as NSError).code
                if errorCode == 17008 {
                    self.alertText = "E-mail está mal formatado."
                } else {
                    self.alertText = error.localizedDescription
                }
            }
        }
        self.showAlert = true
    }
}

