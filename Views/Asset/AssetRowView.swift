//
//  AssetRowView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 25/05/24.
//

import SwiftUI

struct AssetRowView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    let assetName: String
    var asset: Asset? {
        viewModel.assets.first{$0.name == assetName}
    }
    var favorite: Bool {
        viewModel.isAssetFav(assetName: assetName)
    }
    
    var body: some View {
        Group {
            if self.asset == nil {
                Text("Carregando...")
            } else {
                HStack {
                    // NAME
                    Text(self.asset!.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(width: viewModel.assetNameMaxWidth)
                    Spacer()
                    
                    // VARIATION
                    Text(self.asset!.variation.toPercentString())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(self.asset!.variationColor)
                    Spacer()
                    
                    // PRICE
                    let digits = Asset.getDigitsCount(assetName)
                    VStack {
                        Text(self.asset!.currency)
                            .font(.caption2)
                        Text(self.asset!.price.asNumberString(digits))
                            .font(.subheadline)
                    }
                    .foregroundColor(.primary)
                    Spacer()
                    
                    // HIGH & LOW
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(self.asset!.high.asNumberString(digits))
                        Text(self.asset!.low.asNumberString(digits))
                    }
                    .font(.footnote)
                    .foregroundColor(.primary)
                    Spacer()
                    
                    Button {
                        if AuthService.shared.userSession != nil {
                            viewModel.updateUserStaredAssets(assetName)
                        } else {
                            viewModel.showAlert = true
                            viewModel.alertTitle = "Atenção"
                            viewModel.alertMessage = "Você precisa estar logado para favoritar um ativo!"
                        }
                    } label: {
                        if favorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
    
}

//#Preview {
//    AssetRowView(asset: Asset.NVDA, favorite: true)
//}
