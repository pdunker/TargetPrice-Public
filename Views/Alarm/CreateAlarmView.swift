//
//  CreateAlarmView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 19/06/24.
//

import SwiftUI
import Combine

struct CreateAlarmView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var targetPriceTxt = ""
    @State var sendNotification = true
    @State var sendEmail = true
    
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var createAlarmCb: (_ targetPriceTxt: String, _ sendNotif: Bool, _ sendEmail: Bool) -> ()
    
    var createBtnActive: Bool {
        var aux = targetPriceTxt
        aux = aux.replacingOccurrences(of: ",", with: ".")
        if Double(aux) != nil {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Criar Alarme")
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
            
            HStack {
                Text("Preço Alvo")
                    .font(.subheadline)
                    .padding(.horizontal, 24)
                
                TextField("", text: $targetPriceTxt)
                    .keyboardType(.decimalPad)
                    .modifier(TextFieldModifier())
            }
            
            Group {
                Toggle("Notificação", isOn: $sendNotification)
                Toggle("E-mail", isOn: $sendEmail)
            }
            .font(.subheadline)
            .padding(.horizontal, 24)
            
            Button {
                if AuthService.shared.userSession != nil {
                    createAlarmCb(targetPriceTxt, sendNotification, sendEmail)
                    dismiss()
                } else {
                    self.showingAlert = true
                    self.alertTitle = "Atenção"
                    self.alertMessage = "Você precisa estar logado para criar um alarme!"
                }
            } label: {
              Text("Criar")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 360, height: 44)
                .background(createBtnActive ? Color(.systemBlue) : Color(.systemGray5))
                .cornerRadius(8)
            }
            .padding(.vertical)
            .disabled(!createBtnActive)
            
            Spacer()
        }
        .alert(self.alertTitle, isPresented: $showingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(self.alertMessage)
        }
    }
}

#Preview {
    CreateAlarmView(createAlarmCb: { _, _, _ in })
}
