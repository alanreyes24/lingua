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
            Card.self,
            Day.self
            

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
    @StateObject private var calendarManager: CalendarManager
    @StateObject private var pdfManager: PDFManager

    init() {
        let container = sharedModelContainer
        _deckManager = StateObject(wrappedValue: DeckManager(modelContext: container.mainContext))
        _cardManager = StateObject(wrappedValue: CardManager(modelContext: container.mainContext))
        _gptManager = StateObject(wrappedValue: GPTManager(modelContext: container.mainContext))
        _calendarManager = StateObject(wrappedValue: CalendarManager(modelContext: container.mainContext))
        _pdfManager = StateObject(wrappedValue: PDFManager(modelContext: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            
                ContentView()
                .environmentObject(deckManager)
                .environmentObject(cardManager)
                .environmentObject(gptManager)
                .environmentObject(calendarManager)
                .environmentObject(pdfManager)
            
 
        }
        .windowStyle(.hiddenTitleBar)
        .modelContainer(sharedModelContainer)
        
    }
}
