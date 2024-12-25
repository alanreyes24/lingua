//
//  DeckManager.swift
//  Lingua
//
//  Created by Alan Reyes on 12/17/24.
//

import Foundation
import SwiftData

class DeckManager {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addDeck(name: String) {
        let newDeck = Deck(name: name)
        modelContext.insert(newDeck)
    }
    
    
}
