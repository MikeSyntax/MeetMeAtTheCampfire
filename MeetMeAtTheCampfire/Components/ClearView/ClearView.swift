//
//  ClearView.swift
//  MeetMeAtTheCampfire
//
//  Created by Mike Reichenbach on 27.04.24.
//

import SwiftUI

struct ClearView: View {
    var body: some View {
        Image(systemName: "xmark.circle")
            .font(.system(size: 30))
            .foregroundColor(.primary)
            .bold()
    }
}

#Preview {
    ClearView()
}
