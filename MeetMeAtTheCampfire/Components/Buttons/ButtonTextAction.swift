//
//  ButtonTextAction.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 29.02.24.
//

import SwiftUI

struct ButtonTextAction: View {
    
    let iconName: String
    let text: String
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action, label: {
            HStack{
                Image(systemName: iconName)
                Text(text)
            }
            .frame(height: 20)
            .padding(8)
            .background(.cyan)
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.headline)
        })
        .overlay(
                RoundedRectangle(cornerRadius: 10) // Erstellen eines gerundeten Rechtecks als Overlay
                    .stroke(Color.white, lineWidth: 2) // Farbe und Breite des Rahmens festlegen
            )
    }
}

#Preview {
    ButtonTextAction(iconName: "plus", text: "Button"){
        print("Plus")
    }
}
