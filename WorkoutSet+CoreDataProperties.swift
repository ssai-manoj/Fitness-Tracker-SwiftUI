//
//  WorkoutSet+CoreDataProperties.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 09/09/24.
//
//

import Foundation
import CoreData


extension WorkoutSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutSet> {
        return NSFetchRequest<WorkoutSet>(entityName: "WorkoutSet")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var exercise: String?
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Double
    @NSManaged public var duration: Double
    @NSManaged public var workout: Workout?

}

extension WorkoutSet : Identifiable {

}
