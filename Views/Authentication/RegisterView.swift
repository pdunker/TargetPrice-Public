//
//  RegisterView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {

            TitleImageLogo()
                .padding(.bottom)
            
            VStack {
                TextField("Nome de usuário", text: $viewModel.username)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                TextField("Entre seu email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                SecureField("Entre sua senha", text: $viewModel.password)
                    .modifier(TextFieldModifier())
            }
            
            Button {
                Task {
                    try await viewModel.registerUser()
                }
            } label: {
                Text("Cadastrar")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360, height: 44)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            Spacer()
            Spacer()
        }
        .navigationTitle(Text("Cadastro"))
    }
}

#Preview {
    NavigationStack {
        RegisterView(viewModel: LoginViewModel())
    }
}
