//
//  WorkoutRowView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 09/09/24.
//

import SwiftUI

struct WorkoutRowView: View {
    @ObservedObject var workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(workout.name ?? "")
                .font(.title2)
                .bold()
            
            HStack {
                Text(workout.date ?? Date(), style: .date)
                Spacer()
                Text("\(Int(workout.duration)) min")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("\(Int(workout.calories)) cal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(workout.setsArray.count) sets")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
    }
}

//#Preview {
//    WorkoutRowView()
//}
