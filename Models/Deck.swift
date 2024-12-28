//
//  Deck.swift
//  Lingua
//
//  Created by Alan Reyes on 12/17/24.
//

import Foundation
import SwiftData

@Model
class Deck {
    
    var name: String
    var creationDate: Date
    var cards: [Card]
    
    
    // stuff I need to add
    
    // deck color
    // what folder belongs to (maybe)
    
    
    init (name: String, creationDate: Date = Date()) {
        self.name = name;
        self.creationDate = creationDate;
        self.cards = []

    }
    
    
    
    
}
