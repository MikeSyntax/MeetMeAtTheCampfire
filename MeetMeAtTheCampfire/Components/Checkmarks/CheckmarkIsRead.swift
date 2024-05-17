//
//  CheckmarkIsRead.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 10.03.24.
//

import SwiftUI

struct CheckmarkIsRead: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 16))
            .foregroundColor(.blue)
            .shadow(color: .white, radius: 1)
            .padding(.trailing)
    }
}

#Preview {
    CheckmarkIsRead()
}
