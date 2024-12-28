//
//  DeckManager.swift
//  Lingua
//
//  Created by Alan Reyes on 12/17/24.
//

import Foundation
import SwiftData

class DeckManager: ObservableObject {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addDeck(name: String) -> Deck {
        let newDeck = Deck(name: name)
        modelContext.insert(newDeck)
        return newDeck
    }
    
    func pickRandomCard(deck: Deck) -> Card {
        
        let errorCard = Card(question: "Error Question", answer: "Error Answer", deck: Deck(name: "Error Deck"))
        if let randomCard = deck.cards.randomElement() {
            return randomCard
        }
        
        return errorCard
        
    }

    
}
