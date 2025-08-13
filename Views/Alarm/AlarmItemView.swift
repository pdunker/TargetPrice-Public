//
//  AlarmItemView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 10/06/24.
//

import SwiftUI
import Firebase

struct AlarmItemView: View {
    
    let alarm: Alarm
    let showAssetName: Bool
    
    init(alarm: Alarm, showAssetName: Bool = true) {
        self.alarm = alarm
        self.showAssetName = showAssetName
    }
    
    var body: some View {
        HStack {
            Image(systemName: alarm.rang ? "alarm.waves.left.and.right" : "alarm")
                .padding(.leading, alarm.rang ? 0 : 8)
            Spacer()
            if showAssetName {
                Text(alarm.assetName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Spacer()
            }
            HStack(spacing: 2) {
                Text(alarm.targetPriceBelow ? "≤" : "≥" )
                    .font(.headline)

                Text(alarm.targetPrice.asNumberString(Asset.getDigitsCount(alarm.assetName)))
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.leading, 4)
            
            Spacer()
            
            VStack {
                Text(alarm.createdAt.dateValue().mediumDateString())
                if let rangAt = alarm.rangAt {
                    Text(rangAt.dateValue().mediumDateString())
                }
            }
            .font(.caption)
            .padding(.leading, 6)
            .foregroundColor(.secondary)

        }
        .foregroundColor(alarm.rang ? .gray : .primary)
        .padding()
    }
}

#Preview {
    AlarmItemView(alarm: Alarm(id: NSUUID().uuidString,
                               ownerId: NSUUID().uuidString,
                               assetName: "NVDA",
                               targetPrice: 1000,
                               targetPriceBelow: false,
                               createdAt: Timestamp(),
                               rang: true,
                               rangAt: Timestamp()))
}
