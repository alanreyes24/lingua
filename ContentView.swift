import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 240 / 255, green: 214 / 255, blue: 162 / 255),  // Honey (#F0D6A2)
                        Color(red: 255 / 255, green: 248 / 255, blue: 220 / 255) // Cream (#FFF8DC)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Welcome to Lingua")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    Rectangle()
                        .frame(width: 400, height: 200)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .overlay(
                            Text("Start your language journey!")
                                .font(.headline)
                                .foregroundColor(.gray)
                        )
                    
                    NavigationLink(destination: CreateDeck()) {
                        Text("Create a Deck!")
                            .font(.title2)
                            .foregroundColor(.white)
                            
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
