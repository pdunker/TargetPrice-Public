//
//  ContentView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 01/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    //@State private var selectedIndex = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                // ------------------------------
                AlarmListView()
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.selectedTab = 0
                    }
                    .tabItem {
                        Image(systemName: "alarm")
                        Text("Alarmes")
                    }.tag(0)
                // ------------------------------
                AssetsListsView()
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.selectedTab = 1
                    }
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Renda Variável")
                    }.tag(1)
                // ------------------------------
                BondsListsView()
                    //.environmentObject(viewModel)
                    .onAppear {
                        viewModel.selectedTab = 2
                    }
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis.ascending")
                        Text("Renda Fixa")
                    }.tag(2)
                // ------------------------------
                ProfileView()
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.selectedTab = 3
                    }
                    .tabItem {
                        Image(systemName: viewModel.currentUser != nil ? "person.fill" : "person.fill.xmark")
                        Text("Conta")
                    }.tag(3)
                // ------------------------------
            }
            
            if viewModel.selectedTab == 0 && viewModel.loadingAlarms ||
               viewModel.selectedTab == 1 && viewModel.loadingAssets
            {
                CustomLoadingIndicator()
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
}

#Preview {
    ContentView()
}
