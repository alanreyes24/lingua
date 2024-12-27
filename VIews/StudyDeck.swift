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
    @State var showAnswer: Bool = false
    
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
                    CardStudy(geometry: geometry, deck: deck, showAnswer: showAnswer)
                    ConfidenceSelection(geometry: geometry, deck: deck, showAnswer: $showAnswer)
                }
            }
        }
    }
}

#Preview {
    StudyDeck(deck: Deck(name: "Preview Name"))
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
    let showAnswer: Bool
                        
    var body: some View {
        
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.50)
            .foregroundColor(Color.blue)
            .overlay (
                
                HStack {
                    
                    ForEach(deck.cards) { card in
                      
                                HStack {
                                    
                                    Rectangle()
                                        .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.15)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                        .padding(5)
                                        .overlay (
                                            Text(card.question)
                                                .foregroundColor(Color.black)
                                        )
                                        
                                    if (showAnswer) {
                                        
                                        Rectangle()
                                            .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.15)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(20)
                                            .padding(5)
                                            .overlay (
                                                Text(card.answer)
                                                    .foregroundColor(Color.black)
                                            )
                                        
                                    }
                                    
                                    
                                    
                                }

                        
                    }
                }
               
            )
        }
    }

struct ConfidenceSelection: View {
    
    let geometry: GeometryProxy
    let deck: Deck
    @Binding var showAnswer: Bool
    
    var body: some View {
        
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.15)
            .foregroundColor(Color.pink)
            .overlay (
                
                VStack {
                    
                    if (!showAnswer) {
                        
                        Button("Reveal Answer") {
                            showAnswer = true
                        }
                        
                    }
                    
                    
                    if (showAnswer) {
                        HStack {
                            Button("Again") {
                                showAnswer = false
                            }
                            
                            Button("Hard") {
                                showAnswer = false

                            }
                            
                            Button("Good") {
                                showAnswer = false

                            }
                            
                            Button("Easy") {
                                showAnswer = false
                            }
                        }
                    }
                    
                  
                    
                }
                
            )
            
    }
}
