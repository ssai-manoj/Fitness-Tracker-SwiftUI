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
    @State private var isSetUpdated = 0
    
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
        .id(isSetUpdated)
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
        .onReceive(workoutManager.$lastUpdatedSetID) { _ in
            print("Refreshing the view")
            isSetUpdated += 1
            workout.objectWillChange.send()
        }
    }

    private func deleteSets(at offsets: IndexSet) {
        // Implement delete functionality for sets
        for index in offsets{
            let set = workout.setsArray[index]
            workoutManager.deleteSet(set)
        }
        workoutManager.fetchWorkoutSets()
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

extension Workout {
    var setsArray: [WorkoutSet] {
        let setSet = sets as? Set<WorkoutSet> ?? []
        return Array(setSet).sorted { $0.id?.uuidString ?? "" < $1.id?.uuidString ?? "" }
    }
}
