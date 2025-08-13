//
//  AlarmListView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 10/06/24.
//

import SwiftUI
import Firebase

struct AlarmListView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    
    var hasRangAlarm: Bool {
        for alarm in viewModel.alarms {
            if alarm.rang {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Ativo")
                    Spacer()
                    Text("Preço Alvo")
                    Spacer()
                    VStack {
                        Text("Criado em")
                        Text("Tocado em")
                    }
                }
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.horizontal)
                Divider()
                ScrollView {
                    ForEach(viewModel.alarms) { alarm in
                        Menu {
                            Button("Apagar") {
                                viewModel.deleteAlarm(alarm)
                            }
                        } label: {
                            AlarmItemView(alarm: alarm)
                        }
                        Divider()
                    }
                }
                Spacer()
            }
            .navigationTitle("Alarmes 🎯")
            .navigationBarItems(trailing: clearAlarms)
        }
    }
    
    
    var clearAlarms: some View {
        Button {
            viewModel.cleanRangAlarms()
        } label: {
            Image(systemName: "trash.circle")
        }
        .font(.system(size: Defaults.ButtonSize))
        .disabled(!hasRangAlarm)
    }
    
}

//#Preview {
//    AlarmListView(alarms: [Alarm(id: NSUUID().uuidString,
//                                 ownerId: NSUUID().uuidString,
//                                 assetName: "IBM",
//                                 targetPrice: 180,
//                                 targetPriceBelow: false,
//                                 createdAt: Timestamp(),
//                                 rang: false,
//                                 rangAt: nil),
//                           Alarm(id: NSUUID().uuidString,
//                                 ownerId: NSUUID().uuidString,
//                                 assetName: "NVDA",
//                                 targetPrice: 1000,
//                                 targetPriceBelow: false,
//                                 createdAt: Timestamp(),
//                                 rang: true,
//                                 rangAt: Timestamp())])
//}
