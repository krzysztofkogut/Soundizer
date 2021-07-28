//
//  InstrumentListView.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import SwiftUI

struct InstrumentListView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var instrumentListVM = InstrumentListViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.gray]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.gray]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(instrumentListVM.instrumentCellViewModels) { instrumentCellVM in
                    InstrumentCell(instrumentCellVM: instrumentCellVM)
                }
                .onDelete { index in
                    self.instrumentListVM.removeInstrument(atOffsets: index)
                }
            }
        }
        .navigationBarTitle("Instruments")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentListView()
    }
}
