import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query var decks: [Deck]

    var body: some View {
        NavigationStack {
            
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

                // Main Layout
                HStack(spacing: 10) {
                    SidebarView() // Moved sidebar to its own subview
                    MainContentView(decks: decks) // Moved main content to its own subview
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Deck.self, inMemory: true)
}

struct SidebarView: View {
    var body: some View {
        Rectangle()
            .frame(width: 150, height: .infinity)
            .foregroundColor(.blue)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                Text("Lingua")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 15),
                alignment: .top
            )
    }
}

struct MainContentView: View {
    let decks: [Deck]

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(.red)
                .cornerRadius(20)
                .padding(5)
                .overlay(
                    VStack {
                        Spacer()
                        WelcomeView(geometry: geometry)
                        FlashcardsView(geometry: geometry, decks: decks)
                        StudyCalendarView(geometry: geometry)
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
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.10)
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
            .foregroundColor(.purple)
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

                        NavigationLink(destination: CreateDeck()) {
                            Text("Create a deck!")
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.05)
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
                            } else {
                                ForEach(decks) { deck in
                                    DeckView(deck: deck, geometry: geometry)
                                }
                            }
                        }
                    }

                    Spacer()
                }
            )
    }
}

struct DeckView: View {
    
    let deck: Deck
    let geometry: GeometryProxy
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var deckManager: DeckManager

    var body: some View {
        Rectangle()
            .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.20)
            .foregroundColor(.red)
            .cornerRadius(20)
            .padding(5)
            .overlay(
                VStack {
                    
                    ForEach(deck.cards) { card in
                            Text(card.question)
                        }
                    
                    Text(deck.name)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.bottom, 10)
                    
                    NavigationLink(destination: StudyDeck(deck: deck)) {
                        Text("Study")
                    }
                    
                    Button("Delete") {
                        deckManager.deleteDeck(deck: deck)
                    }
                },
                alignment: .bottom
            )
    }
}

struct StudyCalendarView: View {
    let geometry: GeometryProxy

    var body: some View {
        Rectangle()
            .foregroundColor(.green)
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.40)
            .cornerRadius(20)
            .padding(.bottom, 40)
            .overlay(
                HStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.40, height: geometry.size.height * 0.35)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        .padding(.leading, 20)
                        .padding(.bottom, 30)
                        .overlay(
                            Text("Your studying this week:")
                                .foregroundColor(.white)
                        )

                    Spacer()

                    Rectangle()
                        .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.35)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                        .overlay(
                            Text("Imagine a nice calendar here for streaks")
                                .foregroundColor(.white)
                        )
                }
            )
    }
}
