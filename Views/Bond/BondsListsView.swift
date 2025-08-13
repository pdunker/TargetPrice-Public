//
//  BondsListsView.swift
//  Preço Alvo
//
//  Created by Philip Dunker on 14/07/24.
//

import SwiftUI

struct BondsListsView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        
        NavigationStack {
            Text("")
                .navigationTitle("Renda Fixa")
        }
        
    }
}

#Preview {
    BondsListsView()
}
