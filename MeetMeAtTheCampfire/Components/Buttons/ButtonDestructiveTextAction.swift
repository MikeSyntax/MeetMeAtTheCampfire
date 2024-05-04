//
//  ButtonDestructiveTextAction.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 03.05.24.
//

import SwiftUI

struct ButtonDestructiveTextAction: View {
    
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
            .background(.red)
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.headline)
        })
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 2)
        )
    }
}


#Preview {
    ButtonDestructiveTextAction(iconName: "plus", text: "Button"){
        print("Plus")
    }
}
