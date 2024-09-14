//
//  WorkoutsView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 08/09/24.
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var searchText = ""
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                List(filteredWorkouts, id: \.id) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        WorkoutRowView(workout: workout)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle("Workouts")
            .navigationBarItems(trailing: Button(action: { showingAddWorkout = true }) {
                Image(systemName: "plus")
                    .font(.title)
            })
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
            }
            .onAppear {
                workoutManager.fetchWorkouts()
            }
        }
    }
    
    var filteredWorkouts: [Workout] {
        if searchText.isEmpty {
            return workoutManager.savedWorkouts
        } else {
            return workoutManager.savedWorkouts.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    private func deleteWorkouts(at offsets: IndexSet) {
        for index in offsets {
            let workout = workoutManager.savedWorkouts[index]
            workoutManager.deleteWorkout(workout)
        }
        workoutManager.fetchWorkouts()
    }
}



struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search workouts"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}
