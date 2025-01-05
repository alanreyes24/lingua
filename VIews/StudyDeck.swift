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
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var deckManager: DeckManager

    @State var deck: Deck
    @State var showAnswer: Bool = false
    @State var currentCard: Card = Card(question: "Error", answer: "question", deck: Deck(name: "Error Deck"))

    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geometry in
                                    
                    VStack {
                        DeckInfoBar(geometry: geometry, deck: deck)
                        CardStudy(geometry: geometry, deck: deck, showAnswer: showAnswer, currentCard: currentCard)
                            .onAppear {
                                currentCard = deckManager.pickLowestInterval(deck: deck)
                            }
                        ConfidenceSelection(geometry: geometry, deck: deck, showAnswer: $showAnswer, currentCard: $currentCard)
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
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
                .frame(width: geometry.size.width * 0.999, height: geometry.size.height * 0.15)
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
                .frame(width: geometry.size.width * 0.999, height: geometry.size.height * 0.60)
                .foregroundColor(Color.blue)
                .overlay (
                    
                    
                    HStack {
                        
                        Rectangle()
                            .frame(width: geometry.size.width * 0.30, height: geometry.size.height * 0.20)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .padding(5)
                            .overlay (
                                
                                VStack{
                                    
                                    Text(currentCard.question)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color.black)
                                    
                                    Text("\(currentCard.easeFactor)")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 10, weight: .bold))
                                    
                                    Text("\(currentCard.interval)")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 10, weight: .bold))

                                    
                                }
                                
                            )
                        
                        
                        if (showAnswer) {
                            
                            Rectangle()
                                .frame(width: geometry.size.width * 0.30, height: geometry.size.height * 0.20)
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .padding(5)
                                .overlay (
                                    Text(currentCard.answer)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 24, weight: .bold))
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
                .frame(width: geometry.size.width * 0.999, height: geometry.size.height * 0.25)
                .foregroundColor(Color.pink)
                .overlay (
                    
                    VStack {
                        
                        if (!showAnswer) {
                            
                            Rectangle()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .onTapGesture {
                                    showAnswer = true
                                }
                                .overlay (
                                    HStack {
                                        
                                        Image(systemName: "eye.fill")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 20))
                                        
                                        Text("Show Answer")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(Color.black)
                                    }
                                    
                                )
                            
                        }
                        
                        if (showAnswer) {
                            
                            HStack {
                                
                                Rectangle()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        
                                        showAnswer = false
                                        cardManager.modifyEaseFactor(card: currentCard, score: 0)
                                        // currentCard = deckManager.pickRandomCard(deck: deck)
                                        currentCard = deckManager.pickLowestInterval(deck: deck)
                                        
                                    }
                                    .overlay (
                                        
                                        HStack {
                                            
                                            Image(systemName: "arrow.triangle.2.circlepath")
                                                .foregroundColor(Color.red)
                                                .font(.system(size: 20))

                                            Text("Again")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color.red)
                                            
                                        }
                                        

                                    )
                                
                                Rectangle()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        
                                        showAnswer = false
                                        cardManager.modifyEaseFactor(card: currentCard, score: 1.0)
                                        // currentCard = deckManager.pickRandomCard(deck: deck)
                                        currentCard = deckManager.pickLowestInterval(deck: deck)
                                        
                                    }
                                    .overlay (
                                        
                                        HStack {
                                            
                                            Image(systemName: "hand.thumbsdown.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(Color.yellow)
                                            
                                            Text("Hard")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color.yellow)
                                            
                                        }
                                        

                                    )
                                
                                Rectangle()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        
                                        showAnswer = false
                                        cardManager.modifyEaseFactor(card: currentCard, score: 2.0)
                                        // currentCard = deckManager.pickRandomCard(deck: deck)
                                        currentCard = deckManager.pickLowestInterval(deck: deck)
                                        
                                    }
                                    .overlay (
                                        
                                        HStack {
                                            
                                            Image(systemName: "hand.thumbsup.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(Color.blue)
                                            
                                            Text("Good")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color.blue)
                                            
                                        }
                                        
                                        
                                            

                                    )
                                
                                Rectangle()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        
                                        showAnswer = false
                                        cardManager.modifyEaseFactor(card: currentCard, score: 3.0)
                                        //currentCard = deckManager.pickRandomCard(deck: deck)
                                        currentCard = deckManager.pickLowestInterval(deck: deck)
                                        
                                    }
                                    .overlay (
                                        
                                        HStack {
                                            
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 30))
                                                .foregroundColor(Color.green)
                                            
                                            Text("Easy")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color.green)
                                            
                                        }
                                        
                                        
                                    )
                                
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    
                )
            
        }
    }
    
}
