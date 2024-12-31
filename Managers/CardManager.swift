import Foundation
import SwiftData

class CardManager: ObservableObject {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addCard(question: String, answer: String, toDeck deck: Deck) {
        Task { @MainActor in
            let newCard = Card(question: question, answer: answer, deck: deck)
            
            deck.cards.append(newCard)

            modelContext.insert(newCard)

            do {
                try modelContext.save()
                print("Card saved successfully.")
            } catch {
                print("Failed to save new card: \(error.localizedDescription)")
            }
        }
    }
    
    func buildCards(gptResponse: String, toDeck deck: Deck) {
        Task { @MainActor in
            guard let data = gptResponse.data(using: .utf8) else {
                print("Could not convert GPT response to data.")
                return
            }

            do {
                let dictionary = try JSONDecoder().decode([String: String].self, from: data)
                for (key, value) in dictionary {
                    print("Adding card: question = \(key), answer = \(value)")
                    addCard(question: key, answer: value, toDeck: deck)
                }
            } catch {
                print("Failed to decode GPT response: \(error.localizedDescription)")
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
