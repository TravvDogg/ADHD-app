//
//  JournalView.swift
//  ADHD-app
//
//  Created by Travis Lizio on 10/10/2025.
//

import SwiftUI

struct JournalView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Journal")
                .font(.largeTitle.bold())
            ScrollView {
                CaptureFeed()
                    .padding(.vertical)
            }
        }
        .padding()
    }
}

#Preview {
    JournalView()
        .modelContainer(for: Capture.self, inMemory: true)
}
