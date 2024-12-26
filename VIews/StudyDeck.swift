//
//  StudyDeck.swift
//  Lingua
//
//  Created by Alan Reyes on 12/25/24.
//

import Foundation
import SwiftData
import SwiftUI


struct StudyDeck: View {
    
    let deck: Deck
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 240 / 255, green: 214 / 255, blue: 162 / 255),
                        Color(red: 255 / 255, green: 248 / 255, blue: 220 / 255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    DeckInfoBar(geometry: geometry, deck: deck)
                    CardStudy(geometry: geometry, deck: deck)
                    ConfidenceSelection(geometry: geometry, deck: deck)
                }
            }
        }
    }
}

#Preview {
    StudyDeck(deck: Deck(name: "Dummy name"))
}

struct DeckInfoBar: View {
    
    let geometry: GeometryProxy
    let deck: Deck
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.15)
            .foregroundColor(Color.red)
            .overlay(
                Text(deck.name)
                    .font(.system(size: 36, weight: .bold))
            )
    }
}

struct CardStudy: View {
    
    let geometry: GeometryProxy
    let deck: Deck
                        
    var body: some View {
        
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.50)
            .foregroundColor(Color.blue)
            .overlay (
                ForEach(deck.cards) { card in
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.15)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                        .overlay (
                            HStack {
                                Text(card.question)
                                    .foregroundColor(Color.black)
                                Text(card.answer)
                                    .foregroundColor(Color.black)
                            }
                        )
                }
                
                
            )
    }
    
}

struct ConfidenceSelection: View {
    
    let geometry: GeometryProxy
    let deck: Deck
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.25)
            .foregroundColor(Color.pink)
    }
}
