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
            .font(.callout)
            .foregroundColor(.blue)
            .bold()
            .padding(.trailing)
    }
}

#Preview {
    CheckmarkIsRead()
}
