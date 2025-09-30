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
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: {
                    // dismiss action
                }) {
                    Image(systemName: "xmark")
                        .font(.title3.bold())
                        .foregroundColor(.gray)
                }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(.systemGray6))
                        .cornerRadius(37)
                        .frame(height: 37)
                    Text("Capture something \(missionTitle) today!")
                        .font(.subheadline.bold())
                        .padding(.vertical, 8)
                        .foregroundColor(Color(.gray))
                }
                
                Button("Save") {
                    // save action
                }
                .font(.subheadline.bold())
                .foregroundColor(.gray)
            }
            .padding()
            
            // Timer or subtitle
            Text("41:12")
                .font(.caption)
                .padding(.bottom, 8)
            
            // Text field area
            VStack(alignment: .leading) {
                TextField("Add a note or caption for your walk photo...", text: $missionNote)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Spacer()
            
            // Toolbar above keyboard
            HStack(alignment: .bottom) {
                Button(action: {
                    // custom emoji picker
                }) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 32).bold())
                        .foregroundStyle(Color(.systemGray2))
                }
                
                Spacer()
                
                Button(action: {
                    // camera action
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .circular)
                            .frame(width: 93, height: 93)
                            .foregroundStyle(Color(.systemGray5))
                        
                        Image(systemName: "camera")
                            .font(.system(size: 48).bold())
                            .foregroundStyle(Color(.systemGray2))

                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 24))
                            .offset(x: 24, y: 18)
                            .foregroundStyle(Color(.gray))
                            
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
}

#Preview {
    TodaysMissionNote()
}
