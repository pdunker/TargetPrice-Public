//
//  LoginView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import SwiftUI


struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                TitleImageLogo()
                    .padding()
                VStack {
                    TextField("Entre seu email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Entre sua senha", text: $viewModel.password)
                        .modifier(TextFieldModifier())
                }
                Button {
                    Task {
                        try await viewModel.forgotPassword()
                    }
                } label: {
                    Text("Esqueceu sua senha?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                Button {
                    Task {
                        try await viewModel.login()
                    }
                } label: {
                    Text("Entrar")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 44)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                }
                .padding(.vertical)
                NavigationLink {
                    RegisterView(viewModel: viewModel)
                } label: {
                    HStack(spacing: 3) {
                        Text("Não tem uma conta?")
                        Text("Cadastre-se")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                Spacer()
            }
        }
        .alert("Atenção", isPresented: $viewModel.showAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.alertText)
        }
    }
}

//#Preview {
//    LoginView()
//        .environmentObject(LoginViewModel())
//}
