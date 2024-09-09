//
//  AddWorkoutSetView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 09/09/24.
//

import SwiftUI

struct AddWorkoutSetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var workout: Workout
    @State private var exercise = ""
    @State private var reps: Int16 = 0
    @State private var weight = 0.0
    @State private var duration = 0.0

    var body: some View {
        NavigationView {
            Form {
                TextField("Exercise", text: $exercise)
                Stepper("Reps: \(reps)", value: $reps, in: 0...100)
                HStack {
                    Text("Weight")
                    TextField("Weight", value: $weight, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                    Text("kg")
                }
                HStack {
                    Text("Duration")
                    TextField("Duration", value: $duration, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                    Text("seconds")
                }
            }
            .navigationTitle("Add Set")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                workoutManager.addSetToWorkout(workout, exercise: exercise, reps: reps, weight: weight, duration: duration)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

//#Preview {
//    AddWorkoutSetView()
//}
