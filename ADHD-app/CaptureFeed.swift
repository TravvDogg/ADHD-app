import SwiftUI
import SwiftData

struct CaptureFeed: View {
    @Query(sort: [SortDescriptor(\Capture.createdAt, order: .reverse)])
    private var captures: [Capture]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if captures.isEmpty {
                Text("No captures yet. Create one from Today's Mission.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(captures) { capture in
                    CaptureCard(capture: capture)
                }
            }
        }
    }
}

#Preview {
    CaptureFeed()
        .modelContainer(for: Capture.self, inMemory: true)
}
