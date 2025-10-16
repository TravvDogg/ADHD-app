//
//  JournalView.swift
//  ADHD-app
//
//  Created by Travis Lizio on 10/10/2025.
//

import SwiftUI

struct JournalView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 34) {
            HStack(alignment: .top) {
                Text("Journal")
                    .font(.largeTitle.bold())
                Spacer()
                Spacer()
            }
            ScrollView {
                CaptureFeed()
                    .padding(.vertical)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(24)
        .background(Color(.systemGray6))
    }
}

#Preview {
    JournalView()
        .modelContainer(for: Capture.self, inMemory: true)
}
