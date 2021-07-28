//
//  ResultHostView.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import SwiftUI

struct ResultHostView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var instrumentListVM = InstrumentListViewModel()
    @Binding var showingResult: Bool
    
    var onCommit: (Instrument) -> (Void) = { _ in }
    
    var name: String
    var recognizeDate = Date()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Text(name)
                        .font(.largeTitle)
                        .gradientForeground(colors: [.purple, .blue])
                    Text(Self.dateFormatter.string(from: recognizeDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
                
                Spacer()
                
            }
            .navigationBarTitle("Recognized Instrument", displayMode: .inline)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .gradientForeground(colors: [.purple, .blue])
            } ,trailing:
            Button(action: { self.presentationMode.wrappedValue.dismiss()
            let instrument = Instrument(name: name, isFavourite: false)
            self.instrumentListVM.addInstrument(instrument: instrument)
            }) {
                Text("Save")
                    .gradientForeground(colors: [.purple, .blue])
            })
        }
    }
}
