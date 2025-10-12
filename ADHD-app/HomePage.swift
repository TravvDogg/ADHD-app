//
//  HomePage.swift
//  ADHD-app
//
//  Created by Travis Lizio on 26/9/2025.
//

import SwiftUI
import SwiftData

// MARK: - Constants
private enum Constants {
    static let dayViewSize = CGSize(width: 59, height: 92)
    static let profileImageSize: CGFloat = 42
    static let missionCardSize: CGFloat = 80
    static let missionImageSize: CGFloat = 54
}

// MARK: - DateFormatters
private enum DateFormatters {
    static let weekdayShort: DateFormatter = {
        let df = DateFormatter()
        df.locale = .current
        df.setLocalizedDateFormatFromTemplate("EEE")
        return df
    }()

    static let dayMonth: DateFormatter = {
        let df = DateFormatter()
        df.locale = .current
        df.setLocalizedDateFormatFromTemplate("d MMM")
        return df
    }()
}

// MARK: - DayView
/// Displays a single day cell in the horizontal scroll view.
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
            if isCompleted {
                Image("day-completed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
            }
        }
        .frame(width: Constants.dayViewSize.width, height: Constants.dayViewSize.height, alignment: .top)
        .padding(.vertical, 5)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - TodaysMissionCard
/// Displays a mission card with an image and title.
struct TodaysMissionCard: View {
    let imageName: String
    let title: String
    @State private var showMissionModal = false

    var body: some View {
        Button(action: {
            showMissionModal = true
        }) {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray5))
                        .frame(width: Constants.missionCardSize, height: Constants.missionCardSize)
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.missionImageSize, height: Constants.missionImageSize)
                }
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .sheet(isPresented: $showMissionModal) {
            TodaysMission(missionTitle: title, missionImage: imageName)
                .presentationDetents([.medium, .large])
        }
    }
}

// MARK: - TodaysMissionView
/// Displays today's mission section with tasks and cards.
struct TodaysMissionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Mission")
                .font(.title.bold())

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Lets go out for a little walk and take a picture!")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                }
                .padding()
                .overlay(Rectangle().frame(height: 1).foregroundColor(Color(.systemGray5)), alignment: .bottom)

                HStack {
                    TodaysMissionCard(imageName: "imagesearch-rectangle", title: "Square")
                    TodaysMissionCard(imageName: "imagesearch-triangle", title: "Triangle")
                    TodaysMissionCard(imageName: "imagesearch-bicolor", title: "Blue & Green")
                    TodaysMissionCard(imageName: "imagesearch-smile", title: "Smiley")
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 12)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}

// MARK: - HomePage
/// The main home page view displaying user greeting, activity streak, and today's mission.
struct HomePage: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showResetAlert: Bool = false

    @Query(sort: [SortDescriptor(\Capture.createdAt, order: .reverse)])
    private var captures: [Capture]

    var body: some View {
        VStack(alignment: .leading, spacing: 34) {
            headerSection
            VStack() {
                activitySection
                daysScrollSection
            }

            if captures.isEmpty {
                TodaysMissionView()
//                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading) {
                    Text("Today's Journey")
                        .font(.title.bold())
                        .padding(.top, 8)
                    ForEach(captures) { capture in
                        CaptureCard(capture: capture)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .background(Color(.systemGray6))
        .alert("Reset all journeys?", isPresented: $showResetAlert) {
            Button("Delete All", role: .destructive) {
                deleteAllJourneys()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove all of today's journeys and history.")
        }
    }
}

// MARK: - HomePage Subviews
private extension HomePage {
    var streak: Int {
        // Default streak is 25; increment by 1 when there are captures
        captures.isEmpty ? 25 : 26
    }

    var headerSection: some View {
        HStack(alignment: .top) {
            Text("Hi Joshua")
                .font(.largeTitle.bold())
            Spacer()
            Button {
                showResetAlert = true
            } label: {
                Image("profile-picture")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .scaledToFit()
                    .frame(width: Constants.profileImageSize, height: Constants.profileImageSize)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityHidden(true)
        }
    }

    var activitySection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Activities")
                    .font(.title.bold())
                Text(DateFormatters.dayMonth.string(from: Date()))
            //                Text("26 Aug")
                    .foregroundColor(.gray)
            }
            Spacer()
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(streak)")
                    .bold()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray5))
            .cornerRadius(12)
        }
        .padding(.bottom, 4)
    }

    var daysScrollSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 3) {
                ForEach(yesterdayAndNextFive(), id: \.timeIntervalSinceReferenceDate) { date in
                    let dayNumber = Calendar.current.component(.day, from: date)
                    let weekday = DateFormatters.weekdayShort.string(from: date)
                    let isYesterday = Calendar.current.isDate(date, inSameDayAs: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
                    let isToday = Calendar.current.isDateInToday(date)
                    let completed = isYesterday ? true : (isToday ? !captures.isEmpty : hasCapture(on: date))
                    DayView(
                        day: dayNumber,
                        weekday: weekday,
                        isCompleted: completed,
                        isSelected: isToday
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }

    func yesterdayAndNextFive() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        // Start from yesterday (-1) through +5 days ahead: total 7 items
        return (-1...5).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: today)
        }
    }

    func hasCapture(on date: Date) -> Bool {
        let calendar = Calendar.current
        return captures.contains { capture in
            calendar.isDate(capture.createdAt, inSameDayAs: date)
        }
    }

    func deleteAllJourneys() {
        for capture in captures {
            modelContext.delete(capture)
        }
        try? modelContext.save()
    }
}

#Preview {
    MainView()
}
