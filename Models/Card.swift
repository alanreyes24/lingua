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

    init (question: String, answer: String, deck: Deck) {
        self.question = question;
        self.answer = answer;
        self.deck = deck
    }
    
}
