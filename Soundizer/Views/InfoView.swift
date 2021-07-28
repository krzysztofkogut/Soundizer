//
//  InfoView.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 19/12/2020.
//

import SwiftUI

struct InfoView: View {
    
    var body: some View {
        VStack {
            Text("App made by")
                .font(.largeTitle)
                .fontWeight(.light)
                .gradientForeground(colors: [.purple, .blue])
            Text("Krzysztof Kogut")
                .font(.title2)
                .fontWeight(.bold)
            Text("All rights reserved©")
                .font(.footnote)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
