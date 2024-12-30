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
        do {
            try modelContext.save()
        } catch {
            print("Failed to save new card: \(error.localizedDescription)")
        }
    }
    
    func buildCards(gptResponse: String, toDeck deck: Deck) {
        guard let data = gptResponse.data(using: .utf8) else {
            print("Could not convert GPT response to data.")
            return
        }
        if let dictionary = try? JSONDecoder().decode([String: String].self, from: data) {
            for (key, value) in dictionary {
                // Use `self.addCard` instead of creating a new CardManager
                self.addCard(question: key, answer: value, toDeck: deck)
            }
        }
    }
    
    func modifyEaseFactor(card: Card, score: Double) {
        if (card.easeFactor > 1.1 && card.easeFactor < 3.1) {
            card.easeFactor = card.easeFactor - 0.15 + (0.05 * score)
            card.interval  = card.interval * card.easeFactor
        }
        
    }
}
