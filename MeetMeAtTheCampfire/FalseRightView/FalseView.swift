//
//  FalseView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 04.03.24.
//

import SwiftUI

struct FalseView: View {
    var body: some View {
        Image(systemName: "x.circle.fill")
            .font(.title2)
            .foregroundColor(.red)
            .padding(.trailing)
    }
}

#Preview {
    FalseView()
}
