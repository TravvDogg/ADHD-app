//
//  HomePage.swift
//  ADHD-app
//
//  Created by Travis Lizio on 26/9/2025.
//

import SwiftUI

struct DayView: View {
    let day: Int
    let weekday: String
    let isCompleted: Bool
    let isSelected: Bool

    var body: some View {
        VStack {
            Text("\(day)")
                .font(.caption)
            Text(weekday)
                .font(.caption)
            if day == 25 {
                Image("day-completed")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
            }
        }
        .frame(width: 59, height: 92, alignment: .top)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
        )
    }
}

struct TodaysMissionCard: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 80)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                
        }
    }
}

struct TodaysMissionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text("Today's Mission")
                .font(.title.bold())
            
            VStack(alignment: .leading, spacing: 12) {
            //Subtitle
            HStack {
                Text("Lets go out for a little walk and take a picture!")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
            }.padding()
            
            // Cards Row
            .overlay( // Line
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(.systemGray5)),
                alignment: .bottom
                    )
                // Cards
                HStack() {
                    TodaysMissionCard(imageName: "imagesearch-rectangle", title: "Square")
                    TodaysMissionCard(imageName: "imagesearch-triangle", title: "Triangle")
                    TodaysMissionCard(imageName: "imagesearch-bicolor", title: "Blue & Green")
                    TodaysMissionCard(imageName: "imagesearch-smile", title: "A smily shape")
                }.padding(.horizontal)

            }
            .padding(.bottom, 12)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}

struct HomePage: View {
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: - "Hi Joshua"
            HStack {
                Text("Hi Joshua").font(.largeTitle.bold()) // placeholder name and profile picture
                
                Spacer()
                
                Image("profile-picture")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
            }
            
            //MARK: - Activities
            HStack {
                VStack {
                    Text("Activities")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("26 Aug") // Current date
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("25") // Streak
                        .bold()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray5))
                .cornerRadius(12)
            }
            .padding(.bottom, 4)

            
            //TODO: - Make systematic
            ScrollView(.horizontal, showsIndicators: false) { // Placeholder view
                HStack(spacing: 3) {
                    DayView(day: 25, weekday: "Mon", isCompleted: true, isSelected: false)
                    DayView(day: 26, weekday: "Tue", isCompleted: false, isSelected: true)
                    DayView(day: 27, weekday: "Wed", isCompleted: false, isSelected: false)
                    DayView(day: 28, weekday: "Thu", isCompleted: false, isSelected: false)
                    DayView(day: 29, weekday: "Fri", isCompleted: false, isSelected: false)
                    DayView(day: 30, weekday: "Sat", isCompleted: false, isSelected: false)
                    DayView(day: 1, weekday: "Sun", isCompleted: false, isSelected: false)
                }
                .padding(.vertical, 8)
            }
            
            //MARK: - Today's Mission
            TodaysMissionView()
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.all)
        .background(Color(.systemGray6))
    }
}

#Preview {
    MainView()
}
