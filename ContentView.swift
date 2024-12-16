import SwiftUI
import SwiftData



struct ContentView: View {
    
    @State var showingModal = false

   
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
                                VStack {
                                  
                                    NavigationLink(destination: ContentView()) {
                                        
                                        Text("Home")
                                        .font(.headline)
                                        
                                    }
                                    
                                    NavigationLink(destination: CreateDeck()) {
                                        Text("Create a Deck!")
                                            .font(.headline)
                                    }
                                }
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
                                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.20)
                                        .cornerRadius(20)
                                        .padding(5)
                                        .overlay (
                                            Text("Welcome back, " + NSUserName())
                                        )
                                    
                                    Rectangle()
                                        .foregroundColor(Color.purple)
                                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.20)
                                        .cornerRadius(20)
                                        .padding(5)
                                   

                                    Rectangle()
                                        .foregroundColor(Color.green)
                                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.40)
                                        .cornerRadius(20)
                                        .padding(.bottom, 40)
                                    
//                                    Rectangle()
//                                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.1)
//                                        .padding(5)
//                                    
                                }
//                                ,alignment: .top
                                    
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
