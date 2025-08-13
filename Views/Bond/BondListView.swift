//
//  BondListView.swift
//  Preço Alvo
//
//  Created by Philip Dunker on 05/08/24.
//

import SwiftUI

struct BondListView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    let bondName: String
    var bond: Asset?
//    var asset: Asset? {
//        viewModel.assets.first{$0.name == bondName}
//    }
//    var favorite: Bool {
//        viewModel.isAssetFav(bondName: bondName)
//    }
    
    var body: some View {
//        Group {
//            if self.bond == nil {
//                Text("Carregando...")
//            } else {
                HStack {
                    // NAME
                    Text("IPCA+ 2029")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        //.frame(width: viewModel.bondNameMaxWidth)
                    Spacer()
                    
                    // PRICE
                    Text("+6.14%")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Spacer()
                    
                    
                    Button {
                        viewModel.showAlert = true
                        viewModel.alertTitle = "Atenção"
                        viewModel.alertMessage = "Implementar!"
                    } label: {
//                        if favorite {
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.yellow)
//                        } else {
//                            Image(systemName: "star")
//                                .foregroundColor(.gray)
//                        }
                    }
                    
                }
//            }
//        }
//        .padding(.horizontal)
    }
    
}

#Preview {
    BondListView(bondName: "BOND NAME")
}
