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

        
                    
                    Rectangle()
                        .frame(width: .infinity, height: .infinity - 100)
                        .foregroundColor(.red)
                        .cornerRadius(20)
                        .padding(5)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
