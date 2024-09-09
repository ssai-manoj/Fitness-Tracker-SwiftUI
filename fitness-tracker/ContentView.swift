//
//  ContentView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 08/09/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView{
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            WorkoutsView()
                .tabItem{
                    Label("Workouts", systemImage: "figure.walk")
                }
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}


#Preview {
    ContentView()
}
