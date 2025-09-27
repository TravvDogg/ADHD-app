//
//  Today's Mission.swift
//  ADHD-app
//
//  Created by Travis Lizio on 26/9/2025.
//

import SwiftUI

struct TodaysMission: View {
    let missionTitle: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Mission")
                .font(.title).bold()
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundColor(.gray.opacity(0.5))
                
                VStack {
                    Text("Capture something \(missionTitle) today!")
                        .font(.body)
                    
                    Button(action: {
                        // capture action
                    }) {
                        Label("Capture your day!", systemImage: "camera")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview {
    TodaysMission(missionTitle: "(Type)")
}
