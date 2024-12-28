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
    
    func deleteDeck(deck: Deck) {
    
        modelContext.delete(deck)
        
    }
    
   
    
    func pickLowestInterval(deck: Deck) -> Card {
        
        let errorCard = Card(question: "Error question", answer: "Error answer", deck: Deck(name: "Error deck"))
        
        if deck.cards.isEmpty {
            return errorCard
        }
        
        if let lowestIntervalCard = deck.cards.min(by: {$0.interval < $1.interval}) {
            return lowestIntervalCard
        }
        
        return errorCard
        
    }

}
