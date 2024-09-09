//
//  WorkoutDetailView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 09/09/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var workout: Workout
    @State private var showingAddSet = false
    @State private var isEditing = false

    var body: some View {
        List {
            Section(header: Text("Workout Details")) {
                if isEditing {
                    TextField("Name", text: Binding($workout.name)!)
                    DatePicker("Date", selection: Binding($workout.date)!)
                    HStack {
                        Text("Duration")
                        Slider(value: Binding(projectedValue: $workout.duration), in: 0...180, step: 5)
                        Text("\(Int(workout.duration)) min")
                    }
                    HStack {
                        Text("Calories")
                        TextField("Calories", value: Binding($workout.calories), formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                } else {
                    Text("Name: \(workout.name ?? "")")
                    Text("Date: \(workout.date ?? Date(), style: .date)")
                    Text("Duration: \(Int(workout.duration)) minutes")
                    Text("Calories: \(Int(workout.calories))")
                }
            }
            
            Section(header: Text("Sets")) {
                ForEach(workout.setsArray, id: \.self) { set in
                    NavigationLink(destination: SetDetailView(set: set)){
                        WorkoutSetRowView(set: set)
                    }
                }
                .onDelete(perform: deleteSets)
                Button(action: { showingAddSet = true }) {
                    Label("Add Set", systemImage: "plus")
                }
            }
        }
        .navigationTitle(workout.name ?? "")
        .navigationBarItems(trailing: Button(isEditing ? "Done" : "Edit") {
            if isEditing {
                workoutManager.updateWorkout(workout)
            }
            isEditing.toggle()
        })
        .sheet(isPresented: $showingAddSet) {
            AddWorkoutSetView(workout: workout)
        }
    }

    private func deleteSets(at offsets: IndexSet) {
        // Implement delete functionality for sets
    }
}

struct WorkoutSetRowView: View {
    let set: WorkoutSet

    var body: some View {
        VStack(alignment: .leading) {
            Text(set.exercise ?? "")
                .font(.headline)
            Text("Reps: \(set.reps), Weight: \(set.weight, specifier: "%.1f") kg")
            if set.duration > 0 {
                Text("Duration: \(Int(set.duration)) seconds")
            }
        }
        
    }
}

struct SetDetailView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var set: WorkoutSet
    @State private var isEditing = false
    
    var body: some View {
        List {
            Section(header: Text("Set Details")) {
                if isEditing {
                    TextField("Exercise", text: Binding($set.exercise)!)
                    Stepper("Reps: \(set.reps)", value: Binding(
                        get: { Int(set.reps) },
                        set: { newValue in
                            set.reps = Int16(newValue)
                        }
                    ), in: 0...100)
                    HStack {
                        Text("Weight")
                        TextField("Weight", value: Binding($set.weight), formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        Text("kg")
                    }
                    HStack {
                        Text("Duration")
                        TextField("Duration", value: Binding($set.duration), formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        Text("seconds")
                    }
                } else {
                    Text("Exercise: \(set.exercise ?? "")")
                    Text("Reps: \(set.reps)")
                    Text("Weight: \(set.weight, specifier: "%.1f") kg")
                    Text("Duration: \(Int(set.duration)) seconds")
                }
            }
        }
        .navigationTitle(set.exercise ?? "")
        .navigationBarItems(trailing: Button(isEditing ? "Done" : "Edit") {
            if isEditing {
                workoutManager.updateSet(set)
            }
            isEditing.toggle()
        })
    }
}

extension Workout {
    var setsArray: [WorkoutSet] {
        let setSet = sets as? Set<WorkoutSet> ?? []
        return Array(setSet)
    }
}

//#Preview {
//    WorkoutDetailView()
//}
