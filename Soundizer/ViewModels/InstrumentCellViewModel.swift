//
//  InstrumentCellViewModel.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import Foundation
import Combine

class InstrumentCellViewModel: ObservableObject, Identifiable {
    @Published var instrumentRepository = InstrumentRepository()
    @Published var instrument: Instrument
    
    var id = ""
    @Published var isFavouriteStateIconName = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(instrument: Instrument) {
        self.instrument = instrument
        
        $instrument
            .map { instrument in
                instrument.isFavourite ? "star.fill" : "star"
            }
            .assign(to: \.isFavouriteStateIconName, on: self)
            .store(in: &cancellables)
        
        $instrument
            .compactMap { instrument in
                instrument.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $instrument
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { instrument in
                self.instrumentRepository.updateInstrument(instrument)
            }
            .store(in: &cancellables)
    }
}
