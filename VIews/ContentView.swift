import SwiftUI
import SwiftData



struct ContentView: View {
    
    @State var showingModal = false

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
                
                HStack(spacing: 10) {
                        
                        Rectangle()
                            .frame(width: 150, height: .infinity)
                            .foregroundColor(.blue)
                            .cornerRadius(20)
                            .padding(5)
                            .overlay (
                               Text("Lingua")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.top, 15)
                                ,
                               alignment: .top
                                
                            )

                    GeometryReader { geometry in
                        
                        Rectangle()
                            .frame(width: .infinity, height: .infinity)
                            .foregroundColor(.red)
                            .cornerRadius(20)
                            .padding(5)
                            .overlay(
                                
                                VStack {
                                    
                                    
                                    Spacer()
                                    
                                    Rectangle()
                                        .foregroundColor(Color.orange)
                                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.10)
                                        .cornerRadius(20)
                                        .padding(5)
                                        .overlay (
                                            Text("Welcome, " + NSUserName())
                                                .font(.system(size: 36, weight: .bold))
                                                .padding(.leading, 15),
                                            alignment: .leading
                                                
                                        )
                                        
                                    
                                    Rectangle()
                                        .foregroundColor(Color.purple)
                                        .frame(width: geometry.size.width * 0.97, height: geometry.size.height * 0.40)
                                        .cornerRadius(20)
                                        .padding(5)
                                        .overlay (
                                            VStack {
                                                Rectangle()
                                                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.05)
                                                    .foregroundColor(Color.blue)
                                                    .cornerRadius(20)
                                                    .padding(.top, 15)
                                                    .overlay (
                                                        
                                                        alignment: .leading,

                                                        content: {
                                                            
                                                            HStack {
                                                                
                                                                
                                                                Text("Your Flashcards")
                                                                    .font(.system(size: 24, weight: .bold))
                                                                    .padding(.leading, 15)
                                                                    .padding(.top, 10)
                                                                             
                                                                Spacer()
                                                                
                                                                
                                                                NavigationLink(destination: CreateDeck()) {
                                                                    Text("Create a deck!")
                                                                        .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.05)
                                                                        .foregroundColor(Color.black)
                                                                        .background(Color.white)
                                                                        .font(.system(size: 14, weight: .bold))
                                                                        .cornerRadius(20)
                                                                        .padding(.top, 10)
                                                                }
                                                                .buttonStyle(.plain) // Removes default NavigationLink styles, as well as for Buttons
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                        }

                                                       
                                                     
                                                        )
                                                
                                                ScrollView(.horizontal, showsIndicators: true) {
                                                    
                                                    HStack {
                                                            if decks.isEmpty {
                                                                Text("No decks found.")
                                                            } else {
                                                                ForEach(decks) { deck in
                                                                    Rectangle()
                                                                        .frame(width: geometry.size.width * 0.20, height: geometry.size.height * 0.20)
                                                                        .foregroundColor(Color.red)
                                                                        .cornerRadius(20)
                                                                        .padding(5)
                                                                        .overlay (
                                                                            Text(deck.name)
                                                                                .font(.system(size: 10, weight: .bold))
                                                                                .padding(.bottom, 10),
                                                                            alignment: .bottom
                                                                        )
                                                                }
                                                            }
                                                        }
                                                }
                                                
                                                
                                                Spacer()

                                                
                                            }
                                        )
                                        
                                    Rectangle()
                                        .foregroundColor(Color.green)
                                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.40)
                                        .cornerRadius(20)
                                        .padding(.bottom, 40)
                                        .overlay (
                                            HStack {
                                                
                                           
                                                    Rectangle()
                                                        .frame(width: geometry.size.width * 0.40, height: geometry.size.height * 0.35)
                                                        .foregroundColor(Color.black)
                                                        .cornerRadius(20)
                                                        .padding(.leading, 20)
                                                        .padding(.bottom, 30)
                                                    
                                                    Spacer()
                                                    
                                                    Rectangle()
                                                        .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.35)
                                                        .foregroundColor(Color.black)
                                                        .cornerRadius(20)
                                                        .padding(.trailing, 20)
                                                        .padding(.bottom, 30)
                                                    
                                                
                                    }
                                )
                            }
                        )
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
