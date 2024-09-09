//
//  AddWorkoutView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 09/09/24.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var name = ""
    @State private var date = Date()
    @State private var duration = 0.0
    @State private var calories = 0.0

    var body: some View {
        NavigationView {
            Form {
                TextField("Workout Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                HStack {
                    Text("Duration")
                    Slider(value: $duration, in: 0...180, step: 5)
                    Text("\(Int(duration)) min")
                }
                HStack {
                    Text("Calories")
                    TextField("Calories", value: $calories, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                workoutManager.addWorkout(name: name, date: date, duration: duration, calories: calories)
                workoutManager.fetchWorkouts()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    AddWorkoutView()
}
