//
//  InstrumentCell.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import SwiftUI

struct InstrumentCell: View {
    @ObservedObject var instrumentCellVM: InstrumentCellViewModel
        
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .long
      return formatter
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(instrumentCellVM.instrument.name)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .gradientForeground(colors: [.purple, .blue])
                if let recognizedDate = instrumentCellVM.instrument.recognizedDate {
                    let date = recognizedDate.dateValue()
                    Text(Self.dateFormatter.string(from: date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            Spacer()
            Image(systemName: instrumentCellVM.instrument.isFavourite ? "star.fill" : "star")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    self.instrumentCellVM.instrument.isFavourite.toggle()
                }
                .foregroundColor(instrumentCellVM.instrument.isFavourite ? .yellow : .gray)
        }
    }
}
