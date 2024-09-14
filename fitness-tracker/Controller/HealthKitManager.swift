import Foundation
import HealthKit
import Combine



class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    private var cancellables = Set<AnyCancellable>()

    @Published var stepCount: Int = 0
    @Published var caloriesBurned: Int = 0
    @Published var distance: Double = 0
    @Published var activeMinutes: Int = 0
    @Published var isAuthorized: Bool = false
    
    init(){
        authorizeHealthKit()
    }

    func authorizeHealthKit() {
        let healthKitTypes: Set<HKObjectType> = [
            .quantityType(forIdentifier: .stepCount)!,
            .quantityType(forIdentifier: .activeEnergyBurned)!,
            .quantityType(forIdentifier: .distanceWalkingRunning)!,
            .quantityType(forIdentifier: .appleExerciseTime)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("HealthKit authorization error: \(error.localizedDescription)")
                    self?.isAuthorized = false
                } else {
                    print("HealthKit authorization successful")
                    self?.isAuthorized = true
                    self?.fetchHealthData(for: .daily)
                }
            }
        }
    }

    func fetchHealthData(for timeFrame: TimeFrame) {
            guard isAuthorized else { return }

            let endDate = Date()
            let startDate: Date

            switch timeFrame {
            case .daily:
                startDate = Calendar.current.startOfDay(for: endDate)
            case .weekly:
                startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
            case .monthly:
                startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
            case .yearly:
                startDate = Calendar.current.date(byAdding: .year, value: -1, to: endDate)!
            }

            Publishers.CombineLatest4(
                getHealthData(for: .stepCount, from: startDate, to: endDate),
                getHealthData(for: .activeEnergyBurned, from: startDate, to: endDate),
                getHealthData(for: .distanceWalkingRunning, from: startDate, to: endDate),
                getHealthData(for: .appleExerciseTime, from: startDate, to: endDate)
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] steps, calories, distance, activeMinutes in
                self?.stepCount = Int(steps)
                self?.caloriesBurned = Int(calories)
                self?.distance = distance / 1000 // Convert to kilometers
                self?.activeMinutes = Int(activeMinutes)
            }
            .store(in: &cancellables)
        }

        private func getHealthData(for identifier: HKQuantityTypeIdentifier, from startDate: Date, to endDate: Date) -> AnyPublisher<Double, Never> {
            return Future { [weak self] promise in
                self?.queryHealthData(for: identifier, from: startDate, to: endDate) { value in
                    promise(.success(value))
                }
            }
            .eraseToAnyPublisher()
        }

        private func queryHealthData(for identifier: HKQuantityTypeIdentifier, from startDate: Date, to endDate: Date, completion: @escaping (Double) -> Void) {
            guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
                completion(0.0)
                return
            }

            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, _ in
                DispatchQueue.main.async {
                    guard let result = result, let sum = result.sumQuantity() else {
                        completion(0.0)
                        return
                    }
                    let unit: HKUnit
                    switch identifier {
                    case .stepCount:
                        unit = .count()
                    case .activeEnergyBurned:
                        unit = .kilocalorie()
                    case .distanceWalkingRunning:
                        unit = .meter()
                    case .appleExerciseTime:
                        unit = .minute()
                    default:
                        unit = .count()
                    }
                    completion(sum.doubleValue(for: unit))
                }
            }

            healthStore.execute(query)
        }
}
