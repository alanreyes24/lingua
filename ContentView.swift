//
//  ContentView.swift
//  Lingua
//
//  Created by Alan Reyes on 12/4/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 255 / 255, green: 204 / 255, blue: 102 / 255), // gold
                    Color(red: 255 / 255, green: 153 / 255, blue: 51 / 255),  // orange
                    Color(red: 255 / 255, green: 94 / 255, blue: 77 / 255)    // reddish-orange
                ]),
                startPoint: .top, // decides whether gradient starts at the top of the screen
                endPoint: .bottom // decides where the gradient ends
            )
            .edgesIgnoringSafeArea(.all) // Ensures the gradient goes to the window edges
            
            ZStack {
                Rectangle()
                    .frame(width: 400, height: 200)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                Text("Welcome to Lingua")
                    .font(.largeTitle) // Makes the text larger
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
