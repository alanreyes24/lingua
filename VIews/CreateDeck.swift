//
//  CreateDeck.swift
//  Lingua
//
//  Created by Alan Reyes on 12/25/24.
//

import Foundation
import SwiftData
import SwiftUI

struct CreateDeck: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State public var currentDeck: Deck = Deck(name: "")
    @State private var deckName: String = ""
    @State public var currentInputMode: String = ""
    
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
                
                VStack(spacing: 10) {
                    TopBarView(geometry: geometry)
                    ButtonView(geometry: geometry, currentInputMode: $currentInputMode, currentDeck: $currentDeck) // Pass as @Binding
                    InputView(geometry: geometry, currentInputMode: currentInputMode, currentDeck: currentDeck, deckName: deckName)
                }
            }
        }
    }
}

struct TopBarView: View {
    
    let geometry: GeometryProxy
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.15)
            .foregroundColor(Color.blue)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                VStack {
                    Text("Create your deck!")
                        .font(.system(size: 36, weight: .bold))
                    Text("Select a mode to input your material and get learning!")
                        .font(.system(size: 24, weight: .bold))
                }
            )
    }
}

struct ButtonView: View {
    let geometry: GeometryProxy
    
    @Binding var currentInputMode: String // Use @Binding for mutability
    @Binding var currentDeck: Deck
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.30)
            .foregroundColor(Color.purple)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                
                VStack {
                    
                    
                    HStack {
                        TextField("Name your deck...", text: $currentDeck.name)
                    }
                    
                    HStack {
                        Button("manual") {
                            currentInputMode = "manual"
                        }
                        Button("text") {
                            currentInputMode = "text"
                        }
                        Button("gpt") {
                            currentInputMode = "gpt"
                        }
                    }
                    
                }
            )
    }
}

struct InputView: View {
    
    let geometry: GeometryProxy
    let currentInputMode: String
    let currentDeck: Deck
    let deckName: String
    
    @Environment(\.modelContext) private var modelContext
    @State private var currentQuestion: String = ""
    @State private var currentAnswer: String = ""
    
    @State private var gptInput: String = ""
    @State private var gptOutput: String? = nil
    
    @ViewBuilder
    private func inputModeView(geometry: GeometryProxy) -> some View {
        
        if currentInputMode == "text" {
            
            Text("TEXT MODE")
            
        } else if currentInputMode == "manual" {
            
            HStack {
                Rectangle()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        TextField("Enter your question...", text: $currentQuestion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(Color.black)
                            .padding()
                    )
                
                Rectangle()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
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
        } else if currentInputMode == "gpt" {
            
            @Environment(\.modelContext) var modelContext
            let gptManager = GPTManager(modelContext: modelContext)
            
            VStack {
                
                
                Text("GPT MODE")
                
                TextField("Enter the information you want to be turned into flashcards here...", text: $gptInput)
                
                Button("Send message to GPT") {
                    
                    gptManager.sendMessageToGPT(userInput: gptInput) { response in
                        if let response = response {
                            gptOutput = response
                        } else {
                            print("Failed to get a response.")
                        }
                    }
                }
                
                if let response = gptOutput {
                    Text(response)
                        .font(.headline)
                }
                
            }
        }
    }
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.45)
            .foregroundColor(Color.red)
            .cornerRadius(20)
            .padding(5)
            .overlay(inputModeView(geometry: geometry))
    }
}
