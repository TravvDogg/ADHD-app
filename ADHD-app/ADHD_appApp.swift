//
//  ADHD_appApp.swift
//  ADHD-app
//
//  Created by Travis Lizio on 26/9/2025.
//

import SwiftUI
import SwiftData

@main
struct ADHD_appApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
            HomePage()
        }
        .modelContainer(sharedModelContainer)
    }
}
