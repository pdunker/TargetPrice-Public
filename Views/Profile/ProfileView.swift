//
//  ProfileView.swift
//  Preço Alvo
//
//  Created by Philip Dunker on 06/07/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    
    @State var showingLogoutAlert = false
    @State var showingDeleteUserAlert = false
    @State var showAlert = false
    @State var alertMessage = ""
    
    func setAlertMessage(_ message: String) {
        alertMessage = message
        showAlert = true
    }
    
    var body: some View {
        NavigationStack {
            if AuthService.shared.currentUser?.username == nil {
                LoginView()
                    .navigationTitle("Login")
            } else {
                VStack {
                    HStack {
                        Spacer()
                        TitleImageLogo()
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Nome: ")
                            Text(" " + (AuthService.shared.currentUser?.username ?? ""))
                                .frame(width: 250, height: 30, alignment: .leading)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                                .foregroundStyle(.secondary)
                        }
                        HStack {
                            Text("E-mail:")
                            Text(" " + (AuthService.shared.currentUser?.email ?? ""))
                                .frame(width: 250, height: 30, alignment: .leading)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                        Button {
                            showingLogoutAlert.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.forward")
                                    .font(.system(size: Defaults.ToolbarButtonSize))
                                    .rotationEffect(Angle(degrees: 180))
                                Text("Sair")
                            }
                            .foregroundColor(.red)
                        }
                        Divider()
                        Button {
                            showingDeleteUserAlert.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "person.crop.circle.badge.xmark")
                                    .font(.system(size: Defaults.ToolbarButtonSize))
                                Text("Excluir conta")
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .navigationTitle("Conta")
            }
        }
        .alert("Tem certeza que quer sair?", isPresented: $showingLogoutAlert) {
            Button("Sim") {
                Task {
                    await viewModel.logout()
                }
            }
            Button("Não") {}
        }
        .alert("Tem certeza que quer apagar a sua conta?", isPresented: $showingDeleteUserAlert) {
            Button("Sim") {
                Task {
                    await viewModel.deleteAccount({ message in
                        self.setAlertMessage(message)
                    })
                }
            }
            Button("Não") {}
        }
        .alert("Atenção!", isPresented: $showAlert) {
            Button("OK") {}
        } message: {
            Text(self.alertMessage)
        }
    }
}

#Preview {
    ProfileView()
}
