//
//  CustomLoadingIndicator.swift
//  TargetPrice
//
//  Created by Philip Dunker on 12/06/24.
//

import SwiftUI

struct CustomLoadingIndicator: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(.circular)
      .accentColor(.white)
      .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
      .frame(width: 80, height: 80)
      .cornerRadius(20)
  }
}

#Preview {
  CustomLoadingIndicator()
}
