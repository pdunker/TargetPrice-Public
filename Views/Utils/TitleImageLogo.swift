//
//  TitleImageLogo.swift
//  TargetPrice
//
//  Created by Philip Dunker on 25/06/24.
//

import SwiftUI

struct TitleImageLogo: View {
    
    var font: Font {
        let fontName = "RobotoSlab-SemiBold"
        guard let uiFont = UIFont(name: fontName, size: 36) else {
            print("DEBUG: Font \(fontName) not found!")
            return .callout
        }
        return Font(uiFont)
    }
    
    var body: some View {
        VStack(spacing: 5) {
//            Text("Preço Alvo")
//                .font(self.font)
//                .cornerRadius(10)
//            Image(systemName: "target")
//            Text("🎯")
//                .scaleEffect(1.5)
            
            Image("TargetPriceIcon")
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 220)
                .overlay {
                    LinearGradient(stops: [
                        Gradient.Stop(color: .clear, location: 0.9),
                        Gradient.Stop(color: Color(UIColor.systemBackground), location: 0.95)
                    ], startPoint: .bottom, endPoint: .top)
                    
                    LinearGradient(stops: [
                        Gradient.Stop(color: .clear, location: 0.9),
                        Gradient.Stop(color: Color(UIColor.systemBackground), location: 0.95)
                    ], startPoint: .top, endPoint: .bottom)
                    
                    LinearGradient(stops: [
                        Gradient.Stop(color: .clear, location: 0.9),
                        Gradient.Stop(color: Color(UIColor.systemBackground), location: 0.95)
                    ], startPoint: .leading, endPoint: .trailing)
                    
                    LinearGradient(stops: [
                        Gradient.Stop(color: .clear, location: 0.9),
                        Gradient.Stop(color: Color(UIColor.systemBackground), location: 0.95)
                    ], startPoint: .trailing, endPoint: .leading)
                    
                }
//                .border(.blue)
        }
//        .padding(.bottom, 15)
//        .border(.blue)
    }
}

#Preview {
    TitleImageLogo()
}
