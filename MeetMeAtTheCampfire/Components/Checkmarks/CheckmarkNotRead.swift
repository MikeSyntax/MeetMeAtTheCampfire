//
//  CheckmarkNotRead.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 10.03.24.
//

import SwiftUI

struct CheckmarkNotRead: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 16))
            .foregroundColor(.white)
            .shadow(color: .blue, radius: 1)
            .padding(.trailing)
    }
}

#Preview {
    CheckmarkNotRead()
}
