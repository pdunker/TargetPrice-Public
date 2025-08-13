//
//  AssetView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 26/05/24.
//

import SwiftUI

struct AssetView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    @State var assetName: String
    @State var showingAddAlarm = false
    
    var favorite: Bool {
        viewModel.isAssetFav(assetName: assetName)
    }
    var asset: Asset? {
        viewModel.assets.first{$0.name == assetName}
    }
    var alarms: [Alarm] {
        viewModel.alarms.filter({$0.assetName == assetName})
    }
    
    private let arrowsPadding: CGFloat = 6
    private let arrowsSize: CGFloat = 1.75
    
    var body: some View {
        VStack {
            if self.asset == nil {
                Text("Carregando...")
                    .frame(height: 210)
            } else {
                HStack {
                    Text(asset!.fullname)
                        .font(Font.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, -8)
                        .padding(.leading, 18)
                        .lineLimit(1)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        let prevAssetName = viewModel.getPrevAssetFor(assetName: asset!.name) ?? ""
                        Button {
                            assetName = prevAssetName
                        } label: {
                            Image(systemName: "chevron.left.square")
                                .scaleEffect(arrowsSize)
                        }
                        .disabled(prevAssetName == "")
                        .padding(.leading, self.arrowsPadding)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            
                            TitleValueView(title: "Variação",
                                           value: asset!.variation.toPercentString(),
                                           valueBold: true)
                            .foregroundStyle(asset!.variationColor)
                            
                            TitleValueView(title: "Preço",
                                           value: asset!.currency + " " + asset!.price.asNumberString(asset!.digits))
                            
                            TitleValueView(title: "Volume",
                                           value: asset!.volume != -1 ? asset!.volume.formatWithAbbreviations() : "N/A")
                        }
                        
                        Divider()
                            .frame(height: 150)
                        
                        VStack(alignment: .leading) {
                            TitleValueView(title: "Máx.",
                                           value: asset!.currency + " " + asset!.high.asNumberString(asset!.digits))
                            TitleValueView(title: "Min.",
                                           value: asset!.currency + " " + asset!.low.asNumberString(asset!.digits))
                            TitleValueView(title: "Abertura",
                                           value: asset!.currency + " " + asset!.open.asNumberString(asset!.digits))
                        }
                        
                        Spacer()
                        
                        let nextAssetName = viewModel.getNextAssetFor(assetName: asset!.name) ?? ""
                        Button {
                            assetName = nextAssetName
                        } label: {
                            Image(systemName: "chevron.right.square")
                                .scaleEffect(arrowsSize)
                        }
                        .disabled(nextAssetName == "")
                        .padding(.trailing, self.arrowsPadding)
                    }
                    
                    HStack(spacing: 2) {
                        Text("Horário do dado:")
                        Text(asset!.updated.dateNoYearNoSecString())
                        Text("(UTC-3)")
                    }
                    .font(Font.footnote)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 10)
            }
            
            HStack {
                Text("Alarmes")
                    .font(.title3)
                Button {
                    showingAddAlarm.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                            .font(.system(size: Defaults.ButtonSize))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 0)
            
            HStack {
                Spacer()
                Text("Preço Alvo")
                Spacer()
                VStack(alignment: .leading) {
                    Text("Criado em")
                    Text("Tocado em")
                }
            }
            .foregroundColor(.gray)
            .font(.caption)
            .padding(.horizontal)
            
            Divider()
            ScrollView {
                ForEach(self.alarms) { alarm in
                    Menu {
                        Button("Apagar") {
                            viewModel.deleteAlarm(alarm)
                        }
                    } label: {
                        AlarmItemView(alarm: alarm, showAssetName: false)
                    }
                    Divider()
                }
            }
            .refreshable {
                await viewModel.fetchAlarms()
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    if AuthService.shared.userSession != nil {
                        viewModel.updateUserStaredAssets(assetName)
                    } else {
                        viewModel.showAlert = true
                        viewModel.alertTitle = "Atenção!"
                        viewModel.alertMessage = "Você precisa estar logado para favoritar um ativo!"
                    }
                } label: {
                    Image(systemName: self.favorite ? "star.fill" : "star")
                        .foregroundStyle(self.favorite ? .yellow : .gray)
                }
                .font(.system(size: Defaults.ToolbarButtonSize))
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await viewModel.fetchAssetsData()
                        await viewModel.fetchAlarms()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .font(.system(size: Defaults.ToolbarButtonSize))
            }
        }
        .navigationTitle(assetName)
        .sheet(isPresented: $showingAddAlarm, content: {
            CreateAlarmView(createAlarmCb: createAlarm)
                .presentationDetents([.fraction(0.4)])
        })
    }
    
    func createAlarm(_ targetPriceTxt: String, _ sendNotif: Bool, _ sendEmail: Bool) {
        Task {
            await viewModel.addAlarm(assetName: self.assetName,
                                     priceTxt: targetPriceTxt,
                                     sendNotif: sendNotif,
                                     sendEmail: sendEmail)
        }
    }
}

//#Preview {
//    NavigationStack {
//        AssetView(assetName: Asset.NVDA.name, favorite: false)
//    }
//}

struct TitleValueView: View {
    
    let title: String
    let value: String
    var valueBold: Bool
    
    init(title: String, value: String, valueBold: Bool = false) {
        self.title = title
        self.value = value
        self.valueBold = valueBold
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.gray)
                .font(Font.footnote)
            
            Text(value)
                .font(Font.title3)
                .fontWeight(self.valueBold ? .semibold : .regular)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
    }
}
