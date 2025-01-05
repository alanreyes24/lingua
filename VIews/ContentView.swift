import SwiftUI
import SwiftData
import Foundation

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
    
    @State var monthArray: [Day]  = []

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
                        StudyCalendarView(geometry: geometry, monthArray: $monthArray)
                            .onAppear {
                                do {
                                    monthArray = try retrieveCurrentMonthDetails()
                                                                
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                }
                                
                            }
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
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.leading, 15)
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
            .padding(5)
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
    @Binding var monthArray: [Day]
    
    // Define the grid layout with 7 columns for the days of the week
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.40)
            .cornerRadius(20)
            .padding(.bottom, 40)
            .overlay(
                HStack {
                    
                    // Left side: "Your studying this week:"
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
                                    .padding()
                            }
                        )
                    
                    Spacer()
                    
                    // Right side: Calendar Days
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
                                
                                // Use LazyVGrid to allow wrapping
                                
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        ForEach(monthArray) { day in
                                            VStack {
                                                if (day.day > 0) {
                                                    Text("\(day.day)")
                                                        .font(.headline)
                                                        .foregroundColor(.black)
                                                        .frame(width: 30, height: 40)
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
 
func retrieveCurrentMonthDetails() throws -> [Day] {
    var monthArray: [Day] = [] // Initialize the array properly
    
    let calendar = Calendar.current
    let currentDate = Date()
    
    let components = calendar.dateComponents([.year, .month], from: currentDate)
    
    guard let month = components.month, let year = components.year else {
        throw NSError(domain: "RetrieveMonthDetailsError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve year or month from current date."])
    }
    
    let monthYearFormatter = DateFormatter()
    monthYearFormatter.locale = Locale.current
    monthYearFormatter.dateFormat = "LLLL yyyy"
    
    let monthYearString = monthYearFormatter.string(from: currentDate)
    print("\(monthYearString):\n")
    
    let weekdayFormatter = DateFormatter()
    weekdayFormatter.locale = Locale.current
    weekdayFormatter.dateFormat = "EEEE"
    
    guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {
        print("Unable to determine number of days in the current month")
        throw NSError(domain: "RetrieveMonthDetailsError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to determine number of days in the current month."])
    }
    
    for day in range {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        // Generate a Date object from the components.
        if let date = calendar.date(from: dateComponents) {
            // Get the weekday name for the date.
            let weekdayName = weekdayFormatter.string(from: date)
            
            // Create the Day object with unwrapped values.
            let tempDate = Day(year: year, month: month, day: day, dayOfWeek: weekdayName)
            monthArray.append(tempDate)
            
            
            
        } else {
            print("Invalid date for day \(day).")
        }
    }
    
    switch monthArray[1].dayOfWeek {
        
    case "Tuesday":
        
        let placeholderDay = Day(year: 0, month: 0, day: 0, dayOfWeek: "placeholder")

            monthArray.insert(placeholderDay, at: 0)
        
    case "Wednesday":
        
        let placeholderDay = Day(year: 0, month: 0, day: 0, dayOfWeek: "placeholder")

        for _ in 0...1 {
            monthArray.insert(placeholderDay, at: 0)
        }
    case "Thursday":
        
        let placeholderDay = Day(year: 0, month: 0, day: 0, dayOfWeek: "placeholder")

        for _ in 0...2 {
            monthArray.insert(placeholderDay, at: 0)
        }
    case "Friday":
        
        let placeholderDay = Day(year: 0, month: 0, day: 0, dayOfWeek: "placeholder")

        for _ in 0...3 {
            monthArray.insert(placeholderDay, at: 0)
        }
    default:
        
        let placeholderDay = Day(year: 0, month: 0, day: 0, dayOfWeek: "placeholder")

        for _ in 0...1 {
            monthArray.insert(placeholderDay, at: 0)
        }
        
    }
    
    
    
    return monthArray
}
