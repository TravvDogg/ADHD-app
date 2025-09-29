//
//  Today's Mission.swift
//  ADHD-app
//
//  Created by Travis Lizio on 26/9/2025.
//

import SwiftUI

struct TodaysMission: View {
    @State private var showMissionNoteModal: Bool = false

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
        VStack(alignment: .leading) {
            Text("Today's Mission")
                .font(.title).bold()
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundColor(.gray.opacity(0.5))
                VStack {
                    HStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(.systemGray5))
                            Image(missionImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                        }
                        .padding([.top, .trailing], 8)
                    }
                    Spacer()
                }

//                RoundedRectangle(cornerRadius: 12)
                
                VStack {
                    Text("Capture something \(missionTitle) today!")
                        .font(.body)
                    
                    Button(action: {
                        showMissionNoteModal = true
                    }) {
                        Label("Capture your day!", systemImage: "camera")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showMissionNoteModal) {
                        TodaysMissionNote(missionTitle: missionTitle, missionImage: missionImage)
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview {
    TodaysMission()
}
