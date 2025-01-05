//
//  Date.swift
//  Lingua
//
//  Created by Alan Reyes on 1/5/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Day: Identifiable {
    
    var id = UUID()
    var year: Int?
    var month: Int?
    var day: Int
    var dayOfWeek: String
    
    init (year: Int, month: Int, day: Int, dayOfWeek: String) {
        
        self.year = year
        self.month = month
        self.day = day
        self.dayOfWeek = dayOfWeek
        
    }
    
}
