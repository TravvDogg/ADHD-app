//
//  JournalView.swift
//  ADHD-app
//
//  Created by Travis Lizio on 10/10/2025.
//

import SwiftUI

struct JournalView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Journal")
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .center)
            ScrollView {
                CaptureFeed()
//                    .padding(.vertical)
            }
        }
        .padding()
    }
}

#Preview {
    JournalView()
        .modelContainer(for: Capture.self, inMemory: true)
}
