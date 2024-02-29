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
            .frame(height: 30)
            .padding(8)
            .background(.cyan)
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.headline)
        })
    }
}

#Preview {
    ButtonTextAction(iconName: "plus", text: "Button"){
        print("Plus")
    }
}
