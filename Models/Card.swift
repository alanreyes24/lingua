//
//  Card.swift
//  Lingua
//
//  Created by Alan Reyes on 12/25/24.
//

import Foundation
import SwiftData

@Model
class Card {
    
    var question: String
    var answer: String
    var deck: Deck

    var easeFactor: Double = 2.5 // Default value used by Core Data during migration
    var interval: Double = 1.0   // Default value used by Core Data during migration
    
    init(question: String, answer: String, deck: Deck) {
        self.question = question
        self.answer = answer
        self.deck = deck
        // No need to redefine easeFactor and interval here unless overriding defaults
    }
}
