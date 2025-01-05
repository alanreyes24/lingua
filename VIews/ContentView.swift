import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    // 1) SwiftData context to insert or save changes
    @Environment(\.modelContext) private var context
    
    // 2) Query existing Day objects from SwiftData (sorted by `day` ascending)
    @Query(sort: \Day.day, order: .forward) private var days: [Day]
    // 3) Query for Deck objects (assuming Deck is also a SwiftData model)
    @Query var decks: [Deck]
    
    @EnvironmentObject var calendarManager: CalendarManager

    var body: some View {
        NavigationStack {
            HStack(spacing: 10) {
                // Pass 'days' into MainContentView so it can display them
                MainContentView(decks: decks, days: days)
                    .frame(minWidth: 1000, minHeight: 800)
            }
        }
        .task {
            // 4) Ensure we have Day objects for this month in SwiftData
            do {
                try calendarManager.ensureMonthDataExists(for: Date())
            } catch {
                print("Error ensuring month data: \(error.localizedDescription)")
            }
        }
    }
}

struct MainContentView: View {
    let decks: [Deck]
    let days: [Day]  // We'll use the SwiftData Days directly
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(.clear)
                .cornerRadius(20)
                .padding(5)
                .overlay(
                    VStack {
                        Spacer()
                        
                        // Same subviews as before
                        WelcomeView(geometry: geometry)
                        
                        FlashcardsView(geometry: geometry, decks: decks)
                        
                        // Instead of an @State [Day], pass the SwiftData days
                        StudyCalendarView(geometry: geometry, days: days)
                    }
                )
        }
    }
}

struct WelcomeView: View {
    let geometry: GeometryProxy

    var body: some View {
        Rectangle()
            .foregroundColor(.orange)
            .frame(width: geometry.size.width * 0.97, height: geometry.size.height * 0.10)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                Text("Welcome, \(NSUserName())")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.leading, 15),
                alignment: .leading
            )
    }
}

struct FlashcardsView: View {
    let geometry: GeometryProxy
    let decks: [Deck]

    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .frame(width: geometry.size.width * 0.97, height: geometry.size.height * 0.40)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                VStack {
                    HStack {
                        Text("Your Flashcards")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.leading, 15)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        NavigationLink(destination: CreateDeck().navigationBarBackButtonHidden(true)) {
                            Text("Create a deck!")
                                .frame(width: geometry.size.width * 0.15,
                                       height: geometry.size.width * 0.05)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .font(.system(size: 14, weight: .bold))
                                .cornerRadius(20)
                                .padding(.top, 10)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            if decks.isEmpty {
                                Text("No decks found.")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.leading, 15)
                            } else {
                                ForEach(decks) { deck in
                                    DeckView(deck: deck,
                                             geometry: geometry,
                                             deckColor: mapColor(from: deck.color))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            )
    }
    
    // Helper function to map a stored color string to SwiftUI Color
    func mapColor(from colorName: String) -> Color {
        switch colorName.lowercased() {
        case "red":    return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green":  return .green
        case "blue":   return .blue
        case "purple": return .purple
        default:       return .red
        }
    }
}

struct DeckView: View {
    let deck: Deck
    let geometry: GeometryProxy
    let deckColor: Color
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var deckManager: DeckManager

    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.20)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                VStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.15)
                        .foregroundColor(deckColor)
                        .cornerRadius(20)
                        .overlay(
                            Text(deck.name)
                                .font(.system(size: 16, weight: .bold))
                                .padding(.top, 10)
                        )
                    
                    Spacer()
                    
                    HStack {
                        NavigationLink(destination: StudyDeck(deck: deck)
                            .navigationBarBackButtonHidden(true)) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(deckColor)
                                        .cornerRadius(20)
                                        .overlay(
                                            Image(systemName: "book.fill")
                                        )
                                }
                        }
                        .buttonStyle(PlainButtonStyle())

                        Rectangle()
                            .frame(width: geometry.size.width * 0.05,
                                   height: geometry.size.height * 0.02)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(1)
                            .overlay(
                                ZStack {
                                    Rectangle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(deckColor)
                                        .cornerRadius(20)
                                        .overlay(
                                            Image(systemName: "trash.fill")
                                        )
                                }
                            )
                            .onTapGesture {
                                deckManager.deleteDeck(deck: deck)
                            }
                    }
                    .padding(.bottom, 10)
                },
                alignment: .bottom
            )
    }
}

struct StudyCalendarView: View {
    let geometry: GeometryProxy
    
    // We now use the Days from SwiftData, not a @Binding array
    let days: [Day]
    
    // Define a 7-column grid
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: geometry.size.width * 0.95,
                   height: geometry.size.height * 0.40)
            .cornerRadius(20)
            .padding(.bottom, 40)
            .overlay(
                HStack {
                    // Left side: "Your studying this week:"
                    Rectangle()
                        .frame(width: geometry.size.width * 0.40,
                               height: geometry.size.height * 0.35)
                        .foregroundColor(.clear)
                        .cornerRadius(20)
                        .padding(.leading, 20)
                        .padding(.bottom, 30)
                        .overlay(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3)
                                
                                Text("Your studying this week:")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        )
                    
                    Spacer()
                    
                    // Right side: Display each Day
                    Rectangle()
                        .frame(width: geometry.size.width * 0.45,
                               height: geometry.size.height * 0.35)
                        .foregroundColor(.clear)
                        .cornerRadius(20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                        .overlay(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3)
                                
                                LazyVGrid(columns: columns, spacing: 10) {
                                    // Display each Day object
                                    ForEach(days) { day in
                                        VStack {
                                            // Only show real days, skip placeholders if needed
                                            if day.day > 0 {
                                                Text("\(day.day)")
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .frame(width: 50, height: 50)
                                                    .background(Color.white)
                                                    .cornerRadius(8)
                                                    .shadow(radius: 2)
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                        )
                }
            )
    }
}
