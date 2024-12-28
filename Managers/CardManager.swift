//
//  CardManager.swift
//  Lingua
//
//  Created by Alan Reyes on 12/25/24.
//

import Foundation
import SwiftData

class CardManager: ObservableObject {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addCard(question: String, answer: String, toDeck deck: Deck) {
        
        let newCard = Card(question: question, answer: answer, deck: deck)
        deck.cards.append(newCard)
        modelContext.insert(newCard)
        
    }
    
    func modifyEaseFactor(card: Card, score: Double) {
        
        card.easeFactor = card.easeFactor - 0.15 + (0.05 * score)
        
    }
    
}
