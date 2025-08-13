//
//  AssetsListsView.swift
//  TargetPrice
//
//  Created by Philip Dunker on 25/05/24.
//

import SwiftUI
import Firebase

struct AssetsListsView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    let categories = ["Todos", "BR", "EUA", "Cripto", "Fav."]
    
    @State var showingFeedback = false
    
    @FocusState var searchIsFocused: Bool
    
    fileprivate func ColumnTitleButton(column: String, option1: String, option2: String, currSortBy: String) -> Button<HStack<TupleView<(some View, Image?)>>> {
        return Button {
            if currSortBy != option1 {
                viewModel.sortAssets(option1)
            } else {
                viewModel.sortAssets(option2)
            }
        } label: {
            HStack(spacing: 2) {
                Text(column)
                if currSortBy == option1 || currSortBy == option2 {
                    Image(systemName: currSortBy == option1 ? "arrowtriangle.down" : "arrowtriangle.up" )
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                
                HStack(spacing: 0) {
                    Picker(selection: $viewModel.filterByCateg, label: Text("Filtro")) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: viewModel.filterByCateg) {
                        viewModel.applyCategFilter()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal, 2)
                
                HStack {
                    let sortedBy = viewModel.sortedBy
                    ColumnTitleButton(column: "Ativo", option1: "alphabetical", option2: "unalphabetical", currSortBy: sortedBy)
                    Spacer()
                    ColumnTitleButton(column: "Variação", option1: "variation-decreasing", option2: "variation-increasing", currSortBy: sortedBy)
                    Spacer()
                    ColumnTitleButton(column: "Preço", option1: "price-decreasing", option2: "price-increasing", currSortBy: sortedBy)
                    Spacer()
                    VStack {
                        Text("Máx.")
                        Text("Min.")
                    }
                    Spacer()
                }
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.horizontal)
                .padding(.trailing)
                
                Divider()

                ScrollView {
                    
//                    let hideSearch = viewModel.assets.count == 0 && viewModel.searchText == ""
//                    if hideSearch == false {
                        HStack(alignment: .top) {
                            Image(systemName: "magnifyingglass")
                            TextField("Procurar", text: $viewModel.searchText)
                                .disableAutocorrection(true)
                                .focused($searchIsFocused)
                            if viewModel.searchText != "" {
                                Button {
                                    viewModel.searchText = ""
                                    searchIsFocused = false
                                } label: {
                                    Image(systemName: "x.circle")
                                }
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 18)
                        
                        Divider()
//                    }
                    
                    ForEach(viewModel.assets) { asset in
                        NavigationLink(value: asset.name) {
                            AssetRowView(assetName: asset.name)
                                .environmentObject(viewModel)
                        }
                        Divider()
                    }
                }
                .refreshable {
                    await viewModel.fetchAssetsData()
                }
                .overlay {
                    if viewModel.assets.count == 0 && viewModel.filterByCateg == "Fav." {
                        Spacer()
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Sem favoritos")
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Renda Variável")
            .navigationDestination(for: String.self) { assetName in
                AssetView(assetName: assetName)
                    .environmentObject(viewModel)
            }
            .toolbar {
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
            .navigationBarItems(leading: sortMenu)
            .navigationBarItems(trailing: feedback)
            
            Spacer()
        }
        .onChange(of: viewModel.searchText, {
            viewModel.applyCategFilter()
        })
        .sheet(isPresented: $showingFeedback, content: {
            FeedbackView()
                .environmentObject(viewModel)
        })
    }
    
    var sortMenu: some View {
        Menu {
            Text("Ordenar ativos por:")
            Button("Nome") {
                if viewModel.sortedBy != "alphabetical" {
                    viewModel.sortAssets("alphabetical")
                } else {
                    viewModel.sortAssets("unalphabetical")
                }
            }
            Button("Variação (%)") {
                if viewModel.sortedBy != "variation-decreasing" {
                    viewModel.sortAssets("variation-decreasing")
                } else {
                    viewModel.sortAssets("variation-increasing")
                }
            }
            Button("Preço") {
                if viewModel.sortedBy != "price-decreasing" {
                    viewModel.sortAssets("price-decreasing")
                } else {
                    viewModel.sortAssets("price-increasing")
                }
            }
            Button("Volume") {
                if viewModel.sortedBy != "volume-decreasing" {
                    viewModel.sortAssets("volume-decreasing")
                } else {
                    viewModel.sortAssets("volume-increasing")
                }
            }
            Button("Horário do dado") {
                if viewModel.sortedBy != "updated-recently" {
                    viewModel.sortAssets("updated-recently")
                } else {
                    viewModel.sortAssets("updated-oldest")
                }
            }
        } label: {
            Image(systemName: "arrow.up.and.down.text.horizontal") // "slider.horizontal.3", "line.3.horizontal.decrease", "line.3.horizontal.decrease.circle"
                .font(.system(size: Defaults.ToolbarButtonSize))
        }
    }
    
    var feedback: some View {
        Button {
            showingFeedback.toggle()
        } label: {
            Image(systemName: "questionmark.bubble")
                .font(.system(size: Defaults.ToolbarButtonSize))
        }
    }
}

#Preview {
    AssetsListsView()
        .environmentObject(ContentViewModel())
}
