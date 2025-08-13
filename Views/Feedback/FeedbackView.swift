//
//  FeedbackView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 23/06/24.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @Environment(\.dismiss) var dismiss
    @State var messageText = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Feedback")
                    .font(.title3)
                    .padding(.top, 10)
                
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle")
                }
                .font(.system(size: Defaults.ButtonSize))
            }
            .padding()
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    HStack {
                        Spacer()
                        TitleImageLogo()
                        Spacer()
                    }
                    
                    //            Text("Olá " + AuthService.shared.currentUser!.username + ",")
                    Text("Não encontrou um ativo (ação, FII, cripto, stock ou reit)? Envie nos um mensagem com o código do ativo que adicionaremos ao nosso banco de dados.")
                    Text("Críticas e sugestões também são bem-vindas!")
                        .padding(.bottom, 15)
                    
                    TextField("Escreva sua mensagem aqui...", text: $messageText, axis: .vertical)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    
                    HStack {
                        Spacer()
                        Button {
                            if AuthService.shared.userSession != nil {
                                DatabaseService.shared.addFeedback(messageText)
                                viewModel.showAlert = true
                                viewModel.alertTitle = "Mensagem enviada"
                                viewModel.alertMessage = "Em até 5 dias úteis você receberá uma resposta por e-mail. Obrigado!"
                            } else {
                                viewModel.showAlert = true
                                viewModel.alertTitle = "Atenção!"
                                viewModel.alertMessage = "Você precisa estar logado para enviar uma mensagem!"
                            }
                        } label: {
                            Text("Enviar")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 360, height: 44)
                                .background(messageText != "" ? Color(.systemBlue) : Color(.systemGray5))
                                .cornerRadius(8)
                        }
                        .padding(.vertical)
                        .disabled(messageText == "")
                        Spacer()
                    }
                    
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    FeedbackView()
}
