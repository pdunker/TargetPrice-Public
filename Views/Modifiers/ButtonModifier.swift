//
//  ButtonModifier.swift
//  TargetPrice
//
//  Created by Philip Dunker on 19/06/24.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 360, height: 44)
            .background(Color(.systemBlue))
            .cornerRadius(8)
    }
}
