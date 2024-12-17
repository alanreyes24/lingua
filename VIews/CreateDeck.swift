//
//  CreateDeck.swift
//  Lingua
//
//  Created by Alan Reyes on 12/13/24.
//

import SwiftUI

struct CreateDeck: View {
    
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
            
            VStack {
                
                TextField("Enter deck name", text: $deckName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Create Deck") {
                    
                    let manager = DeckManager(modelContext: modelContext)
                    manager.addDeck(name: deckName)
                    print("Added Deck " + deckName)
                }
                
            }
            
        }
    }
}

#Preview {
    CreateDeck()
}
