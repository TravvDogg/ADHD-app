//
//  SummaryView.swift
//  ADHD-app
//
//  Created by Travis Lizio on 16/10/2025.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 34) {
                Text("Summary")
                    .font(.largeTitle.bold())
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Calendar")
                        .font(.title.bold())
                        .padding(.top, 8)
                        .padding(.horizontal, 24)
                    
                    Image("summary-calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("Overall")
                        .font(.title.bold())
                        .padding(.top, 8)
                        .padding(.horizontal, 24)
                    
                    Image("summary-overview")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    SummaryView()
}
