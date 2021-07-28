//
//  View.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 18/12/2020.
//

import SwiftUI

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .top,
                                    endPoint: .bottom))
            .mask(self)
    }
}
