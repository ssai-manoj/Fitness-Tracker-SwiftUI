//
//  fitness_trackerApp.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 08/09/24.
//

import SwiftUI

@main
struct fitness_trackerApp: App {
    let workoutManager = WorkoutManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutManager)
        }
    }
}
