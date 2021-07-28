//
//  Instrument.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Instrument: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var isFavourite: Bool
    @ServerTimestamp var recognizedDate: Timestamp?
    var userID: String?
}
