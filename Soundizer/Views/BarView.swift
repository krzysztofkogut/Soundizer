//
//  BarView.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import SwiftUI

struct BarView: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var value: CGFloat

    var body: some View {
        ZStack {
            if value > 25 {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                         startPoint: .top,
                                         endPoint: .bottom))
                    .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
            } else {
                withAnimation(.linear(duration: 2)) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                }
            }
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 25.0)
    }
}
