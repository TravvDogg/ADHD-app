//
//  MainView.swift
//  ADHD-app
//
//  Created by Travis Lizio on 26/9/2025.
//

import SwiftUI

struct MainView: View {
    init() {
        // Set the background color of the tab bar to white
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        // Optional: set tint colors
        UITabBar.appearance().tintColor = UIColor.systemBlue
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray

        // Apply the appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            Text("Journal Page Placeholder")
                .tabItem {
                    Image(systemName: "magazine")
                    Text("Journal")
                }

            Text("Summary Page Placeholder")
                .tabItem {
                    Image(systemName: "text.document")
                    Text("Summary")
                }
        }
    }
}

#Preview {
    MainView()
}
