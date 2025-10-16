//
//  SummaryView.swift
//  ADHD-app
//
//  Created by Travis Lizio on 16/10/2025.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        Image("tmp-summary")
            .resizable()
            .scaledToFill()
//            .ignoresSafeArea()
//            .padding(.top)
            .accessibilityHidden(true)
    }
}

#Preview {
    SummaryView()
}
