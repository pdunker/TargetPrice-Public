//
//  TextFieldModifier.swift
//  TargetPrice
//
//  Created by Philip Dunker on 31/05/24.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
