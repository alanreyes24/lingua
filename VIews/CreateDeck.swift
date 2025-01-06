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
             
                VStack(spacing: 10) {
                    TopBarView(geometry: geometry, currentStep: currentStep)
                    MiddleView(geometry: geometry, currentInputMode: $currentInputMode, currentStep: $currentStep, currentDeck: $currentDeck)
                }
        }
    }
        .frame(minWidth: 1000, minHeight: 800)

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
        
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white, lineWidth: 3)
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.15)
            .foregroundColor(Color.clear)
            .cornerRadius(20)
            .padding(.leading, 25)
            .padding(.top, 10)
            .overlay(
                                                    
                    VStack {
                        
                        switch currentStep {
                            
                        case "design":
                                                    
                            Text("Design the look of your deck!")
                                .font(.system(size: 36, weight: .bold))
                                                
                        case "fill":
                            
                            Text("Select a mode to input your material!")
                                .font(.system(size: 36, weight: .bold))
                            
                        case "created":
                            
                            Text("Your deck has been created!")
                                .font(.system(size: 36, weight: .bold))

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
            .foregroundColor(Color.clear)
            .cornerRadius(20)
            .padding(.leading, 25)
            .overlay(
                
                VStack {
                    
                    switch currentStep {
                        
                    case "design":
                        
                        DesignView(geometry: geometry, currentDeck: $currentDeck, currentStep: $currentStep, deckColor: $deckColor)
                        
                    case "fill":
                        
                        FillView(geometry: geometry, currentInputMode: currentInputMode, currentDeck: $currentDeck, currentStep: $currentStep)
                        
                    case "created":
                        
                        CreatedView(geometry: geometry, currentDeck: currentDeck, deckColor: deckColor)
                        
                    default:
                        
                        VStack {
                            Text("Error")
                        }
                        
                    }
                    
                    
                }
                
            )
        
        
    }
    }

struct DesignView: View {
    
    let geometry: GeometryProxy
    @Binding var currentDeck: Deck
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
                
                PickColor(geometry: geometry, currentDeck: $currentDeck, deckColor: $deckColor)
                
                
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
    @Binding var currentDeck: Deck

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
                            currentDeck.color = "red"

                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.orange)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.orange
                            currentDeck.color = "orange"

                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.yellow)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.yellow
                            currentDeck.color = "yellow"

                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.green)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.green
                            currentDeck.color = "green"

                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.blue
                            currentDeck.color = "blue"

                        }
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.04, height: geometry.size.height * 0.06)
                        .foregroundColor(.purple)
                        .cornerRadius(20)
                        .onTapGesture {
                            deckColor = Color.purple
                            currentDeck.color = "purple"

                        }
                
                }
                
            )
        
    }
    
}

struct FillView: View {
    
    let geometry: GeometryProxy
    @State var currentInputMode: String
    @Binding var currentDeck: Deck
    @Binding var currentStep: String
    
    @State var gptButtonPressed: Bool = false
    @State var gptRequestFinished: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @State private var currentQuestion: String = ""
    @State private var currentAnswer: String = ""
    
    @State private var gptInput: String = ""
    @State private var gptOutput: String? = nil
    @State private var showPDFPicker: Bool = true
        
    @ViewBuilder
    private func inputModeView(geometry: GeometryProxy) -> some View {
        
        if currentInputMode == "manual" {
            
            VStack {
                
                HStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.15)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            
                            ZStack(alignment: .center) {
                                
                                if currentQuestion.isEmpty {
                                    
                                    Text("Enter your question...")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                
                                }
                                         
                                         TextField("", text: $currentQuestion)
                                             .foregroundColor(Color.black)
                                             .multilineTextAlignment(.center)
                                             .textFieldStyle(PlainTextFieldStyle()) // Removes default styling
                                             .padding()
                                
                            }
                            
                        )
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.15)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            
                            ZStack(alignment: .center) {
                                
                                if currentAnswer.isEmpty {
                                    
                                    Text("Enter your answer...")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                
                                }
                                         
                                         TextField("", text: $currentAnswer)
                                             .foregroundColor(Color.black)
                                             .multilineTextAlignment(.center)
                                             .textFieldStyle(PlainTextFieldStyle()) // Removes default styling
                                             .padding()
                                
                            }
                            
                            
                            
                        )
                    
                    
                } .padding(.top, 25)
                
                Rectangle()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.05)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    .padding(25)
                    .overlay (
                        
                        Text("Add Card")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                            
                        
                    )
                    .onTapGesture {
                        
                        let manager = CardManager(modelContext: modelContext)
                        manager.addCard(question: currentQuestion, answer: currentAnswer, toDeck: currentDeck)
                        currentQuestion = ""
                        currentAnswer = ""
                        
                    }
                
                Rectangle()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.05)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    .padding(25)
                    .overlay (
                        
                        Text("Finish Deck")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                        
                    )
                
                    .onTapGesture {
                        
                        currentStep = "created"
                        
                    }

            }
            
            
        } else if currentInputMode == "gpt" {
            
            let gptManager = GPTManager(modelContext: modelContext)
            
            VStack {
                
                    
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.white)
                        .padding(20)
                    TextEditor(text: $gptInput)
                        .padding(30)
                        .scrollContentBackground(.hidden) // Hide default background
                        .foregroundColor(Color.black)
                }
                .frame(width: geometry.size.width * 0.60, height: geometry.size.height * 0.30)
            
                
                Rectangle()
                    .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.05)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    .overlay (
                        
                        Text("Generate Cards")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20, weight: .bold))
                    )
                    .onTapGesture {
                        
                        gptButtonPressed = true
                        currentInputMode = "generating"
                        
                        gptManager.sendMessageToGPT(userInput: gptInput) { response in
                            
                            
                            if let response = response {
                                gptOutput = response
                                
                                gptButtonPressed = false
                                gptRequestFinished = true
                                currentStep = "created"

                                if let jsonCards = gptOutput {
                                    
                                    let cardManager = CardManager(modelContext: modelContext)
                                    cardManager.buildCards(gptResponse: jsonCards, toDeck: currentDeck)
                                    
                                    
                                }
                                
                            } else {
                                print("Failed to get a response.")
                            }
                            
    
                            
                            
                            
                        }
                        
                    }
            }
            
        } else if currentInputMode == "pdf" {
            
            // 1) Create an instance of PDFManager
            let pdfManager = PDFManager(modelContext: modelContext)
            
            // 2) A button to show the NSOpenPanel (via pdfManager)
            Button("Send PDF") {
                showPDFPicker = true
            }
            // 3) Present PDF picker in a sheet
            .sheet(isPresented: $showPDFPicker) {
                pdfManager.openPDFPanel { pdfURL in
                    // User picked a PDF
                    showPDFPicker = false
                    
                    // 4) Create GPTManager and send the PDF
                    let gptManager = GPTManager(modelContext: modelContext)
                    gptManager.sendPDFtoGPT(pdfURL: pdfURL) { response in
                        DispatchQueue.main.async {
                            guard let jsonResponse = response else {
                                print("No response or PDF extraction error.")
                                return
                            }
                            // `jsonResponse` is the JSON-only output from your model
                            print("Received JSON response: \(jsonResponse)")
                            
                            // 5) Build cards from the response
                            let cardManager = CardManager(modelContext: modelContext)
                            cardManager.buildCards(gptResponse: jsonResponse, toDeck: currentDeck)
                            
                            // 6) Update navigation or UI state
                            currentStep = "created"
                        }
                    }
                }
            }
        
            
        } else if currentInputMode == "generating" {
            
                VStack {
                    
                    Text("Generating your cards...")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color.white)
                        .padding(50)
                    
                    Image(systemName: "circle.dotted")
                        .font(.system(size: 80))
                        .foregroundColor(Color.white)
                        .symbolEffect(.rotate)
                    
                }
            
        }
                    
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white, lineWidth: 3)
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.80)
            .foregroundColor(Color.clear)
            .padding(.leading, 25)
            .overlay(
                
                VStack {
                    
                    Group {
                        
                        if currentInputMode != "generating" {
                            
                            VStack {
                                HStack {
                                    Rectangle()
                                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            VStack {
                                                Text("AI")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .padding(3)
                                                
                                                Image(systemName: "display")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 25))
                                            }
                                        )
                                        .onTapGesture {
                                            currentInputMode = "gpt"
                                        }
                                    
                                    Rectangle()
                                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            VStack {
                                                Text("PDF")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .padding(3)
                                                
                                                Image(systemName: "document.badge.plus.fill")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 25))
                                            }
                                        )
                                        .onTapGesture {
                                            currentInputMode = "pdf"
                                        }
                                    
                                    Rectangle()
                                        .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.2)
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            VStack {
                                                Text("Manual")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .padding(3)
                                                
                                                Image(systemName: "pencil.and.scribble")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 25))
                                            }
                                        )
                                        .onTapGesture {
                                            currentInputMode = "manual"
                                        }
                                } .padding(.leading, 22)
                                
                            }
                            
                        }
                                                
                        inputModeView(geometry: geometry)

                        }
                    
                }
                             
                
                

                )
                }
    }

struct CreatedView: View {
    
    let geometry: GeometryProxy
    let currentDeck: Deck
    let deckColor: Color
    
    var body: some View {
        
        VStack {
            
            Text("Study your deck now!")
                .font(.system(size: 24, weight: .bold))
            
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
                
                
            }
            
            HStack {
                
                
                ForEach(currentDeck.cards) { card in
                    
                    
                    Text("\(card.question)")
                    Text("\(card.answer)")

                    
                }
            }
           
            
            Text("...Or go back home!")
                .font(.system(size: 24, weight: .bold))

            NavigationLink(destination: ContentView()) {
                Text("Home")
            }
            
            
        }
        
    }
    
}

