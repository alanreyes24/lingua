import Foundation
import SwiftData
import SwiftUI

struct CreateDeck: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State var currentDeck: Deck = Deck(name: "New Deck")
    @State private var currentInputMode: String = ""
    
    @State var currentStep: String = "design"
    
    
    
    
    var body: some View {
        NavigationStack {
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
                    TopBarView(geometry: geometry, currentStep: currentStep)
                    MiddleView(geometry: geometry, currentInputMode: $currentInputMode, currentStep: $currentStep, currentDeck: $currentDeck)
                }
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
}

struct TopBarView: View {
    
    let geometry: GeometryProxy
    let currentStep: String
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.15)
            .foregroundColor(Color.blue)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                VStack {
                    
                    switch currentStep {
                        
                    case "design":
                        
                        Text("Create your deck!")
                            .font(.system(size: 36, weight: .bold))
                        Text("Design the look of your deck")
                            .font(.system(size: 24, weight: .bold))
                        
                        
                        
                    case "fill":
                        
                        Text("Enter the information you want in the deck!")
                            .font(.system(size: 36, weight: .bold))
                        Text("Select a mode to input your material and get learning!")
                            .font(.system(size: 24, weight: .bold))
                        
                    default:
                        
                        Text("Error step")
                            .font(.system(size: 36, weight: .bold))
                        
                    }
                    
                    
                   
                }
            )
    }
}

struct MiddleView: View {
    
    let geometry: GeometryProxy
    
    @Binding var currentInputMode: String
    @Binding var currentStep: String
    @Binding var currentDeck: Deck
    @State var deckColor: Color = Color.red
    
    var body: some View {
        
        Rectangle()
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.80)
            .foregroundColor(Color.purple)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                
                VStack {
                    
                    if (currentStep == "design") {
                                                
                        DesignView(geometry: geometry, currentDeck: currentDeck, currentStep: $currentStep, deckColor: $deckColor)
                        
                        
                    }
                    
                    
                    if (currentStep == "fill") {
                        FillView(geometry: geometry, currentInputMode: currentInputMode, currentDeck: currentDeck)
                    }
                    
                    
                }
            )
    }
}

struct DesignView: View {
    
    let geometry: GeometryProxy
    @State var currentDeck: Deck
    @Binding var currentStep: String
    @Binding var deckColor: Color
    
    var body: some View {
        
        HStack {
            
            Rectangle()
                .frame(width: geometry.size.width * 0.40, height: geometry.size.height * 0.40)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(5)
                .overlay(
                    VStack {
                        
                        Rectangle()
                            .frame(width: geometry.size.width * 0.40, height: geometry.size.height * 0.35)
                            .foregroundColor(deckColor)
                            .cornerRadius(20)
                            .overlay (
                                
                                Text(currentDeck.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                            )
                             
                        

                    },
                    alignment: .top
                )
            
            VStack {
                
                Text("Name:")
                    .font(.system(size: 30, weight: .bold))

                
                TextField("", text: $currentDeck.name)
                    .frame(width: geometry.size.width * 0.40)
                
                Text("Color:")
                    .font(.system(size: 30, weight: .bold))
                
                PickColor(geometry: geometry, deckColor: $deckColor)
                
                Rectangle()
                    .frame(width: geometry.size.width * 0.10, height: geometry.size.height * 0.05)
                    .foregroundColor(.blue)
                    .overlay (
                        Text("Create Deck")
                    )
                
                    .onTapGesture {
                        currentStep = "fill"
                    }
                
            }
            
            
            
            

        }
        
        
    }
    
}

struct PickColor: View {
    
    let geometry: GeometryProxy
    
    @Binding var deckColor: Color
    
    var body: some View {
        
        Rectangle()
            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.15)
            .cornerRadius(20)
            .overlay (
                
                HStack {
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.red)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.red
                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.orange)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.orange
                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.yellow)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.yellow
                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.green)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.green
                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.blue
                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.purple)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.purple
                        }
                
                }
                
            )
        
    }
    
}

struct FillView: View {
    
    let geometry: GeometryProxy
    @State var currentInputMode: String
    let currentDeck: Deck
    
    @State var gptButtonPressed: Bool = false
    @State var gptRequestFinished: Bool = false
    
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
            
            let gptManager = GPTManager(modelContext: modelContext)
            
            VStack {
                
                
                Text("GPT MODE")
                
                TextField("Enter the information you want to be turned into flashcards here...", text: $gptInput)
                    .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.20)
                
                Button("Send message to GPT") {
                    
                    
                    gptButtonPressed = true
                    
                    gptManager.sendMessageToGPT(userInput: gptInput) { response in
                        
                        
                        if let response = response {
                            gptOutput = response
                            
                            gptButtonPressed = false
                            gptRequestFinished = true

                            if let jsonCards = gptOutput {
                                
                                let cardManager = CardManager(modelContext: modelContext)
                                cardManager.buildCards(gptResponse: jsonCards, toDeck: currentDeck)
                                
                                
                            }
                            
                        } else {
                            print("Failed to get a response.")
                        }
                    }
                }
                
                if (gptButtonPressed) {
                    
                    Text("Your cards are currently being created...")
                    
                }
                
                if (gptRequestFinished) {
                    
                    Text("Your cards have finished being created!")

                }
                
                
            }
        }
    }
    
    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.3)
            .foregroundColor(Color.red)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                VStack {
                    
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
                    
                    inputModeView(geometry: geometry)

                }
            )
    }
}



