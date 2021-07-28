//
//  InstrumentsRepository.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class InstrumentRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var instruments = [Instrument]()
    
    init() {
        loadData()
    }
    
    func addInstrument(_ instrument: Instrument) {
        do {
            var addedInstrument = instrument
            addedInstrument.userID = Auth.auth().currentUser?.uid
            let _ = try db.collection("instruments").addDocument(from: addedInstrument)
        }
        catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func loadData() {
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("instruments")
                .order(by: "recognizedDate")
                .whereField("userID", isEqualTo: userID)
                .addSnapshotListener { (query, error) in
                    if let query = query {
                        self.instruments = query.documents.compactMap { document in
                            do {
                                let x = try document.data(as: Instrument.self)
                                return x
                            }
                            catch {
                                print(error)
                            }
                            return nil
                        }
                    }
                }
        }
    }
    
    func updateInstrument(_ instrument: Instrument) {
        if let instrumentID = instrument.id {
            do {
                try db.collection("instruments").document(instrumentID).setData(from: instrument)
            }
            catch {
                fatalError("\(error.localizedDescription)")
            }
        }
    }
    
    func removeInstrument(_ instrument: Instrument) {
        if let instrumentID = instrument.id {
            db.collection("instruments").document(instrumentID).delete { (error) in
                if let error = error {
                    print("Cannot remove document: \(error.localizedDescription)")
                }
            }
        }
    }
}
