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
            .font(.callout)
            .foregroundColor(.white)
            .padding(.trailing)
    }
}

#Preview {
    CheckmarkNotRead()
}
