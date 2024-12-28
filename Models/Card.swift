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

    var easeFactor: Double = 1.0
    var interval: Double = 1.0
    
    init (question: String, answer: String, deck: Deck) {
        self.question = question;
        self.answer = answer;
        self.deck = deck
        self.easeFactor = 1.0 // they say this should be 2.5 but idk experiment with it
        self.interval = 1.0
    }
    
}
