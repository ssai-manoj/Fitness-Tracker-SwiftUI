//
//  SetDetailView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 09/09/24.
//

import SwiftUI

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
