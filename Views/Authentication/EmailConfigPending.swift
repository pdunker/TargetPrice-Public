//
//  EmailConfigPending.swift
//  TargetPrice
//
//  Created by Philip Dunker on 18/06/24.
//

import SwiftUI
import FirebaseAuth

struct EmailConfPending: View {
    
    var body: some View {
        VStack {
            Spacer()
            TitleImageLogo()
            
            VStack(alignment: .leading) {
                Text("")
                Text("Enviamos um e-mail com um link de confirmação.\n")
                //Text("Acesse para entrar no ") + Text("Preço Alvo").fontWeight(.bold) + Text("!")
                Text("Após acessar clique em Recarregar,")
                Text("caso não tenha recebido, clique em Reenviar,")
                Text("ou vá em Sair e entre novamente.")
                Text("")
            }
            .modifier(TextFieldModifier())
            
            
            Group {
                Button {
                    AuthService.shared.reloadUserSession()
                } label: {
                    Text("Recarregar").modifier(ButtonModifier())
                }
                Button {
                    Task {
                        try await Auth.auth().currentUser?.sendEmailVerification()
                    }
                } label: {
                    Text("Reenviar").modifier(ButtonModifier())
                }
                Button {
                    AuthService.shared.logout()
                } label: {
                    Text("Sair").modifier(ButtonModifier())
                }
            }
            .padding(.vertical, 8)
            .padding(.top, 8)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    EmailConfPending()
}
