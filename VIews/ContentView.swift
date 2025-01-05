import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query var decks: [Deck]

    var body: some View {
        NavigationStack {
            
//            ZStack {
//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color(red: 240 / 255, green: 214 / 255, blue: 162 / 255),
//                        Color(red: 255 / 255, green: 248 / 255, blue: 220 / 255)
//                    ]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .edgesIgnoringSafeArea(.all)

                HStack(spacing: 10) {
                    MainContentView(decks: decks)
                }
            }
        }
    }
//}

struct MainContentView: View {
    let decks: [Deck]

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .foregroundColor(Color.clear)
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
            .foregroundColor(.clear)
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
            .foregroundColor(.clear)
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
                                    DeckView(deck: deck, geometry: geometry, deckColor: mapColor(from: deck.color))
                                }
                            }
                        }
                    }

                    Spacer()
                }
            )
    }

    // Helper function to map color names to Color values
    func mapColor(from colorName: String) -> Color {
        switch colorName.lowercased() {
            case "red":
                return .red
            case "orange":
                return .orange
            case "yellow":
                return .yellow
            case "green":
                return .green
            case "blue":
                return .blue
            case "purple":
                return .purple
            default:
                return .red // Default color
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
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .padding(1)
            .overlay(
                        
                VStack {
        
                    Rectangle()
                        .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.13)
                        .foregroundColor(deckColor)
                        .cornerRadius(20)
                        .overlay (
                            
                            Text(deck.name)
                                .font(.system(size: 16, weight: .bold))
                                .padding(.top, 10)

                            
                        )
                
                    Spacer()
                    
                    HStack {
                        
                        NavigationLink(destination: StudyDeck(deck: deck).navigationBarBackButtonHidden(true)) {
                            ZStack {
                                
//                                Rectangle()
//                                    .frame(width: geometry.size.width * 0.05, height: geometry.size.height * 0.02)
//                                    .foregroundColor(.white)
//                                    .padding(1)
//                                    .cornerRadius(20)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 20)
//                                            .stroke(deckColor, lineWidth: 1)
//                                    )
                                
                                Rectangle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(deckColor)
                                    .cornerRadius(20)
                                    .overlay (
                                        Image(systemName: "book.fill")
                                    )
                                
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes default NavigationLink styling
                                                
                        Rectangle()
                            .frame(width: geometry.size.width * 0.05, height: geometry.size.height * 0.02)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .padding(1)
                            .overlay (
                                
                                ZStack {
                                    
                                    
                                    Rectangle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(deckColor)
                                        .cornerRadius(20)
                                        .overlay (
                                            Image(systemName: "trash.fill")
                                        )
                                    
                                    
                                }
                                
                                
                                
                            )
                            .onTapGesture {
                                
                                deckManager.deleteDeck(deck: deck)

                                
                            }

                    } .padding(.bottom, 10)
                    
                    
                },
                alignment: .bottom
            )
    }
}

struct StudyCalendarView: View {
    let geometry: GeometryProxy

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.40)
            .cornerRadius(20)
            .padding(.bottom, 40)
            .overlay(
                HStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.40, height: geometry.size.height * 0.35)
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
                                
                            }
                            
                            
                        )

                    Spacer()

                    Rectangle()
                        .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.35)
                        .foregroundColor(.clear)
                        .cornerRadius(20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                        .overlay(
                            
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 3)
                                
                                
                                Text("Imagine a nice calendar here for streaks")
                                    .foregroundColor(.white)
                                
                            }
                            
                        )
                }
            )
    }
}
