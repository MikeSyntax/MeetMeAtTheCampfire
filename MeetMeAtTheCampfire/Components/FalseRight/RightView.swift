//
//  RightView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct RightView: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.title2)
            .foregroundColor(.green)
            .padding(.trailing)
    }
}

#Preview {
    RightView()
}
