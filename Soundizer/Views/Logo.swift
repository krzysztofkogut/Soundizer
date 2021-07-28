//
//  Logo.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 18/12/2020.
//

import SwiftUI

let levels: [CGFloat] = [50,100,150,200,250,250,200,150,100,50]

struct Logo: View {
    var body: some View {
        HStack(spacing: 4) {
            ForEach(levels, id: \.self) { level in
                BarView(value: level)
            }
        }
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
