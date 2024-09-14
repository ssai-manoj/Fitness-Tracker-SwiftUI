//
//  DashboardView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 08/09/24.
//

import SwiftUI

enum TimeFrame: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

struct DashboardView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @State private var animationTrigger = false
    @State private var selectedTimeFrame: TimeFrame = .daily
    
    
    
    var body: some View {
        if healthKitManager.isAuthorized {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Picker("Time Frame", selection: $selectedTimeFrame) {
                        ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                            Text(timeFrame.rawValue).tag(timeFrame)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Steps
                    AnimatedStepView(
                        steps: healthKitManager.stepCount,
                        goal: goalForTimeFrame(baseGoal: 10000),
                        animationTrigger: $animationTrigger,
                        timeFrame: selectedTimeFrame
                    )
                    
                    // Calories
                    AnimatedCalorieView(
                        calories: healthKitManager.caloriesBurned,
                        goal: goalForTimeFrame(baseGoal: 500),
                        animationTrigger: $animationTrigger,
                        timeFrame: selectedTimeFrame
                    )
                    
                    // Distance
                    AnimatedDistanceView(
                        distance: Double(healthKitManager.distance),
                        goal: goalForTimeFrame(baseGoal: 5.0),
                        animationTrigger: $animationTrigger,
                        timeFrame: selectedTimeFrame
                    )
                    
                    // Activity Minutes
                    AnimatedActivityView(
                        minutes: healthKitManager.activeMinutes,
                        goal: goalForTimeFrame(baseGoal: 30),
                        animationTrigger: $animationTrigger,
                        timeFrame: selectedTimeFrame
                    )
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle("Dashboard")
            .onAppear {
                healthKitManager.authorizeHealthKit()
                fetchDataForTimeFrame()
            }
            .onChange(of: selectedTimeFrame) { _ in
                fetchDataForTimeFrame()
            }
        } else {
            Text("Loading...")
        }
    }
    
    private func fetchDataForTimeFrame() {
        // Reset animation trigger
        animationTrigger = false
        
        // Fetch data based on selected time frame
        healthKitManager.fetchHealthData(for: selectedTimeFrame)
        
        // Trigger animation after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                animationTrigger = true
            }
        }
    }
    
    private func goalForTimeFrame(baseGoal: Int) -> Int {
        switch selectedTimeFrame {
        case .daily:
            return baseGoal
        case .weekly:
            return baseGoal * 7
        case .monthly:
            return baseGoal * 30
        case .yearly:
            return baseGoal * 365
        }
    }
    
    private func goalForTimeFrame(baseGoal: Double) -> Double {
        switch selectedTimeFrame {
        case .daily:
            return baseGoal
        case .weekly:
            return baseGoal * 7
        case .monthly:
            return baseGoal * 30
        case .yearly:
            return baseGoal * 365
        }
    }
}

struct AnimatedStepView: View {
    let steps: Int
    let goal: Int
    @Binding var animationTrigger: Bool
    let timeFrame: TimeFrame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "figure.walk")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("Steps (\(timeFrame.rawValue))")
                    .font(.headline)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: geometry.size.width, height: 20)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: animationTrigger ? min(CGFloat(steps) / CGFloat(goal) * geometry.size.width, geometry.size.width) : 0, height: 20)
                }
            }
            .frame(height: 20)
            .cornerRadius(10)
            
            Text("\(steps) / \(goal)")
                .font(.title2)
                .bold()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color(UIColor.systemGray5), radius: 5, x: 0, y: 5)
        )
    }
}

struct AnimatedCalorieView: View {
    let calories: Int
    let goal: Int
    @Binding var animationTrigger: Bool
    @State private var waveOffset = Angle(degrees: 0)
    let timeFrame: TimeFrame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "flame")
                    .font(.title)
                    .foregroundColor(.orange)
                Text("Calories")
                    .font(.headline)
            }
            
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.3), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: animationTrigger ? CGFloat(min(Double(calories) / Double(goal), 1.0)) : 0)
                    .stroke(Color.orange, lineWidth: 10)
                    .rotationEffect(Angle(degrees: -90))
                
                WaveView(progress: CGFloat(min(Double(calories) / Double(goal), 1.0)), waveHeight: 5, offset: waveOffset)
                    .fill(Color.orange.opacity(0.5))
                    .clipShape(Circle().scale(0.95))
                
                Text("\(calories)")
                    .font(.title)
                    .bold()
                
                Text("kcal")
                    .font(.caption)
                    .offset(y: 25)
            }
            .frame(height: 150)
            .animation(.linear(duration: 1.0), value: animationTrigger)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color(UIColor.systemGray5), radius: 5, x: 0, y: 5)
        )
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct AnimatedDistanceView: View {
    let distance: Double
    let goal: Double
    @Binding var animationTrigger: Bool
    let timeFrame: TimeFrame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "ruler")
                    .font(.title)
                    .foregroundColor(.green)
                Text("Distance")
                    .font(.headline)
            }
            
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                    }
                    .stroke(Color.green.opacity(0.3), lineWidth: 4)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                        path.addLine(to: CGPoint(x: animationTrigger ? min(CGFloat(distance / goal) * geometry.size.width, geometry.size.width) : 0, y: geometry.size.height / 2))
                    }
                    .stroke(Color.green, lineWidth: 4)
                    
                    Circle()
                        .fill(Color.green)
                        .frame(width: 20, height: 20)
                        .offset(x: animationTrigger ? min(CGFloat(distance / goal) * geometry.size.width, geometry.size.width) - 10 : -10, y: geometry.size.height / 2 - 10)
                }
            }
            .frame(height: 40)
            
            Text(String(format: "%.2f km", distance))
                .font(.title2)
                .bold()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color(UIColor.systemGray5), radius: 5, x: 0, y: 5)
        )
    }
}

struct AnimatedActivityView: View {
    let minutes: Int
    let goal: Int
    @Binding var animationTrigger: Bool
    let timeFrame: TimeFrame
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "stopwatch")
                    .font(.title)
                    .foregroundColor(.purple)
                Text("Activity Minutes")
                    .font(.headline)
            }
            
            HStack(spacing: 4) {
                ForEach(0..<12, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.purple.opacity(index < Int(Double(minutes) / Double(goal) * 12) ? 1 : 0.3))
                        .frame(width: 20, height: animationTrigger ? 100 * (CGFloat(index + 1) / 12) : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(Double(index) * 0.05), value: animationTrigger)
                }
            }
            
            Text("\(minutes) min")
                .font(.title2)
                .bold()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color(UIColor.systemGray5), radius: 5, x: 0, y: 5)
        )
    }
}

struct WaveView: Shape {
    var progress: CGFloat
    var waveHeight: CGFloat
    var offset: Angle
    
    var animatableData: AnimatablePair<CGFloat, Double> {
        get { AnimatablePair(progress, offset.degrees) }
        set {
            progress = newValue.first
            offset = Angle(degrees: newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let progressHeight: CGFloat = (1 - progress) * rect.height
        let waveWidth = rect.width
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        
        for x in stride(from: 0, through: waveWidth, by: 1) {
            let relativeX = x / waveWidth
            let sine = sin(relativeX * .pi * 4 + offset.radians)
            let y = progressHeight + sine * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}
