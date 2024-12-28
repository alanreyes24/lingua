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
    
    @EnvironmentObject var deckManager: DeckManager
    var deck: Deck
    @State var showAnswer: Bool = false
    @State var currentCard: Card = Card(question: "Error Question", answer: "Error Answer", deck: Deck(name: "Error Deck"))
    @Environment(\.modelContext) private var modelContext

    
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
                    CardStudy(geometry: geometry, deck: deck, showAnswer: showAnswer, currentCard: currentCard)
                    ConfidenceSelection(geometry: geometry, deck: deck, showAnswer: $showAnswer, currentCard: $currentCard)
                }
            }
        }
    }
}

struct DeckInfoBar: View {
    
    let geometry: GeometryProxy
    let deck: Deck
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.15)
            .foregroundColor(Color.red)
            .overlay(
                HStack {
                    Text(deck.name)
                        .font(.system(size: 36, weight: .bold))
                    Text("\(deck.cards.count)")
                }
                
            )
    }
}

struct CardStudy: View {
    
    let geometry: GeometryProxy
    let deck: Deck
    let showAnswer: Bool
    var currentCard: Card
                        
    var body: some View {
        
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.50)
            .foregroundColor(Color.blue)
            .overlay (
                
                      
                                HStack {
                                    
                                    Rectangle()
                                        .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.15)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                        .padding(5)
                                        .overlay (
                                            
                                            VStack{
                                                
                                                Text(currentCard.question)
                                                    .foregroundColor(Color.black)
                                                
                                                Text("\(currentCard.easeFactor)")
                                                    .foregroundColor(Color.black)
                                                
                                                Text("\(currentCard.interval)")
                                                    .foregroundColor(Color.black)
                                                
                                            }
                                            
                                        )
                                        
                                    if (showAnswer) {
                                        
                                        Rectangle()
                                            .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.15)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(20)
                                            .padding(5)
                                            .overlay (
                                                Text(currentCard.answer)
                                                    .foregroundColor(Color.black)
                                            )
                                        
                                    }
                                    
                                    
                                    
                                }

                        
                    
                
                
                
               
            )
        }
    }

struct ConfidenceSelection: View {
    
    let geometry: GeometryProxy
    let deck: Deck
    @Binding var showAnswer: Bool
    @Binding var currentCard: Card
    @EnvironmentObject var deckManager: DeckManager
    @EnvironmentObject var cardManager: CardManager


    
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
                                cardManager.modifyEaseFactor(card: currentCard, score: 0)
                                currentCard = deckManager.pickRandomCard(deck: deck)

                            }
                            
                            Button("Hard") {
                                showAnswer = false
                                cardManager.modifyEaseFactor(card: currentCard, score: 1.0)
                                currentCard = deckManager.pickRandomCard(deck: deck)


                            }
                            
                            Button("Good") {
                                showAnswer = false
                                cardManager.modifyEaseFactor(card: currentCard, score: 2.0)
                                currentCard = deckManager.pickRandomCard(deck: deck)


                            }
                            
                            Button("Easy") {
                                showAnswer = false
                                cardManager.modifyEaseFactor(card: currentCard, score: 3.0)
                                currentCard = deckManager.pickRandomCard(deck: deck)
                                

                            }
                        }
                    }
                    
                  
                    
                }
                
            )
            
    }
}

