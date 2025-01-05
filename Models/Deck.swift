//
//  Deck.swift
//  Lingua
//
//  Created by Alan Reyes on 12/17/24.
//

import Foundation
import SwiftData
import SwiftUI


@Model
class Deck {
    
    var name: String
    var creationDate: Date
    var cards: [Card]
    var color: String
    
    
    // stuff I need to add
    
    // what folder belongs to (maybe)
    
    
    init (name: String, creationDate: Date = Date()) {
        
        self.name = name;
        self.creationDate = creationDate;
        self.cards = []
        self.color = "red"

    }
    
    
    
    
}
