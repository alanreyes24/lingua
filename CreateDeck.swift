//
//  CreateDeck.swift
//  Lingua
//
//  Created by Alan Reyes on 12/13/24.
//

import SwiftUI

struct CreateDeck: View {
    var body: some View {
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
            
            
            VStack {
                Text("Create Deck")
                    .frame(width: 200, height: 50)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(20)
            }
        }
    }
}

#Preview {
    CreateDeck()
}
