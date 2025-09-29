//
//  TodaysMissionNote.swift
//  ADHD-app
//
//  Created by Travis Lizio on 28/9/2025.
//

import SwiftUI

struct TodaysMissionNote: View {
    @State private var missionNote: String = ""
    @FocusState private var isFocused: Bool  // Controls focus

    let missionTitle: String
    let missionImage: String
    
    init(
        // Set defaults
        missionTitle: String = "Default",
        missionImage: String = "imagesearch-rectangle"
    ) {
        // Or use given values
        self.missionTitle = missionTitle
        self.missionImage = missionImage
    }
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(.systemGray5))
                        .cornerRadius(32)
                    
                    Text("Capture something \(missionTitle) today!")
                        .font(.caption)
                        .padding(.vertical, 8)
                        .foregroundColor(Color(.gray))
                    
                }
            }
            .frame(height: 32)


                TextField("Add a note or caption for your walk photo...", text: $missionNote)
                    .textFieldStyle(.plain)
                    .focused($isFocused) // Link to focus state
                    .padding()
            }
            .padding(.top)
            .onAppear {
                // Automatically focus when view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
        }
}

#Preview {
    TodaysMissionNote()
}
