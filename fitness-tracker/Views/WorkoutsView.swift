//
//  WorkoutsView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 08/09/24.
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(workoutManager.savedWorkouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        WorkoutRowView(workout: workout)
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddWorkout, content: {
            AddWorkoutView()
        })
        .onAppear{
            workoutManager.fetchWorkouts()
        }
    }
    
    private func deleteWorkouts(at offsets: IndexSet){
        for index in offsets {
            let workout = workoutManager.savedWorkouts[index]
            workoutManager.deleteWorkout(workout)
        }
        workoutManager.fetchWorkouts()
    }
}

//#Preview {
//    WorkoutsView()
//}
