//
//  CreateDeck.swift
//  Lingua
//
//  Created by Alan Reyes on 12/13/24.
//

import Foundation
import SwiftData
import SwiftUI

struct CreateDeck: View {
    

    @State public var currentDeck: Deck
    @State private var currentQuestion: String = ""
    @State private var currentAnswer: String = ""
    
    @ViewBuilder
    private func inputModeView(geometry: GeometryProxy) -> some View {
        
        if (currentInputMode == "text") {
            
            
            
            
            
        } else if (currentInputMode == "manual") {
            
            HStack {
                
                Rectangle()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay (
                        TextField("Enter your question...", text: $currentQuestion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(Color.black)
                            .padding()
                    )
                
                Rectangle()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                    .background(Color.white)
                    .cornerRadius(20)

                    
                    .overlay (
                        TextField("Enter your answer...", text: $currentAnswer)
                            .foregroundColor(Color.black)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    )

               
                
                Button("Add card") {
                    let manager = CardManager(modelContext: modelContext)
                    manager.addCard(question: currentQuestion, answer: currentAnswer, toDeck: currentDeck)
                    currentQuestion = ""
                    currentAnswer = ""
                }
                
            }
            
        } else if (currentInputMode == "pdf") {
            
            Text("Hellooo222")

        }
        
    }
    
    @State var currentInputMode = "";
    
    @Environment(\.modelContext) private var modelContext
    @State private var deckName: String = ""
    
    var body: some View {
        
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
            
                
                Rectangle()
                    .frame(width: .infinity, height: .infinity)
                    .foregroundColor(Color.blue)
                    .overlay (
                        
                        GeometryReader { geometry in
                            
                            VStack {
                                
                                Rectangle()
                                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.5)
                                    .foregroundColor(Color.red)
                                
                                    .overlay (
                                        
                                        VStack {
                                            
                                            HStack {
                                                Button("Text") {
                                                    // makes deck input be based on text
                                                    currentInputMode = "text"
                                                }
                                                Button("Manual") {
                                                    // makes deck input be based on what user inputs directly
                                                    currentInputMode = "manual"
                                                }
                                                Button("PDF") {
                                                    // makes deck input be based on inputted PDF
                                                    currentInputMode = "pdf"
                                                }
                                              
                                            }
                                            
                                            Text("Mode: " + currentInputMode)

                                            Rectangle()
                                                .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.20)
                                                .foregroundColor(Color.yellow)
                                                .overlay (inputModeView(geometry: geometry))
                                            
                                            
                                            
                                            TextField("Enter deck name", text: $deckName)
                                                .textFieldStyle(.roundedBorder)
                                                .padding()
                                            
                                            Button("Create Deck") {
                                                let manager = DeckManager(modelContext: modelContext)
                                                currentDeck = manager.addDeck(name: deckName)
                                            }
                                            
                                        }
                                        
                                        
                                    )
                                
                                
                            }
                            
                        }
                        
                    )
                            
                        
               }
            }
                        
        }
    


#Preview {
    CreateDeck(currentDeck: Deck(name: "Preview Deck"))
}
