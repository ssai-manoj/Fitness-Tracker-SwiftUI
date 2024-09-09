//
//  WorkoutManager.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 08/09/24.
//

import CoreData

class WorkoutManager: ObservableObject{
    let container: NSPersistentContainer
    @Published var savedWorkouts: [Workout] = []
    @Published var savedWorkoutSets: [WorkoutSet] = []
    
    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "fitness_tracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
            container.loadPersistentStores { (storeDescription, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext(){
        let context = container.viewContext;
        if context.hasChanges{
            do{
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func addWorkout(name: String, date: Date, duration: Double, calories: Double) {
            let newWorkout = Workout(context: container.viewContext)
            newWorkout.id = UUID()
            newWorkout.name = name
            newWorkout.date = date
            newWorkout.duration = duration
            newWorkout.calories = calories
        
            saveContext()
    }
    
    func deleteWorkout(_ workout: Workout) {
            container.viewContext.delete(workout)
            saveContext()
    }
    
    func updateWorkout(_ workout: Workout) {
            saveContext()
    }
    
    func addSetToWorkout(_ workout: Workout, exercise: String, reps: Int16, weight: Double, duration: Double) {
        let newSet = WorkoutSet(context: container.viewContext)
        newSet.id = UUID()
        newSet.exercise = exercise
        newSet.reps = reps
        newSet.weight = weight
        newSet.duration = duration
        newSet.workout = workout

        saveContext()
    }

    func fetchWorkouts() {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Workout.date, ascending: false)]

        do {
            savedWorkouts = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching workouts: \(error)")
        }
    }
    
    func fetchWorkoutSets() {
        let request: NSFetchRequest<WorkoutSet> = WorkoutSet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutSet.exercise, ascending: false)]

        do {
            savedWorkoutSets = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching workouts: \(error)")
        }
    }
    
    func updateSet(_ set: WorkoutSet){
        saveContext()
    }
    
}
