//
//  LinguaApp.swift
//  Lingua
//
//  Created by Alan Reyes on 12/4/24.
//

import SwiftUI
import SwiftData

@main
struct LinguaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Deck.self,
            Card.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // Create shared managers for Deck and Card
    @StateObject private var deckManager: DeckManager
    @StateObject private var cardManager: CardManager
    @StateObject private var gptManager: GPTManager

    init() {
        let container = sharedModelContainer
        _deckManager = StateObject(wrappedValue: DeckManager(modelContext: container.mainContext))
        _cardManager = StateObject(wrappedValue: CardManager(modelContext: container.mainContext))
        _gptManager = StateObject(wrappedValue: GPTManager(modelContext: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            
                ContentView()
                .environmentObject(deckManager) // Inject DeckManager globally
                .environmentObject(cardManager) // Inject CardManager globally
                .environmentObject(gptManager) // Inject GPTManager globally
            
 
        }
        .windowStyle(.hiddenTitleBar)
        .modelContainer(sharedModelContainer)
        
    }
}
