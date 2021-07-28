//
//  InstrumentListViewModel.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import Foundation
import Combine

class InstrumentListViewModel: ObservableObject {
    @Published var instrumentRepository = InstrumentRepository()
    @Published var instrumentCellViewModels = [InstrumentCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        instrumentRepository.$instruments.map { instruments in
            instruments.map { instrument in
                InstrumentCellViewModel(instrument: instrument)
            }
        }
        .assign(to: \.instrumentCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func removeInstrument(atOffsets index: IndexSet) {
      let viewModels = index.lazy.map { self.instrumentCellViewModels[$0] }
      viewModels.forEach { instrumentCellViewModel in
        instrumentRepository.removeInstrument(instrumentCellViewModel.instrument)
      }
    }
    
    func addInstrument(instrument:  Instrument) {
        instrumentRepository.addInstrument(instrument)
    }
}
