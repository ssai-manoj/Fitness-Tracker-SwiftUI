//
//  WorkoutRowView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 09/09/24.
//

import SwiftUI

struct WorkoutRowView: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.name ?? "")
                .font(.headline)
            Text(workout.date ?? Date(), style: .date)
                .font(.subheadline)
            Text("Duration: \(Int(workout.duration)) minutes")
                .font(.subheadline)
        }
    }
}

//#Preview {
//    WorkoutRowView()
//}
