//
//  ProfileView.swift
//  fitness-tracker
//
//  Created by Sai Manoj Dogiparthi on 08/09/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var name = "John Doe"
    @State private var age = 30
    @State private var height = 175.0
    @State private var weight = 70.0
    @State private var goal = "Lose weight"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    Stepper("Age: \(age)", value: $age, in: 18...100)
                    HStack {
                        Text("Height:")
                        Slider(value: $height, in: 100...250, step: 0.5)
                        Text("\(height, specifier: "%.1f") cm")
                    }
                    HStack {
                        Text("Weight:")
                        Slider(value: $weight, in: 30...200, step: 0.1)
                        Text("\(weight, specifier: "%.1f") kg")
                    }
                }
                
                Section(header: Text("Fitness Goal")) {
                    Picker("Goal", selection: $goal) {
                        Text("Lose weight").tag("Lose weight")
                        Text("Gain muscle").tag("Gain muscle")
                        Text("Improve endurance").tag("Improve endurance")
                        Text("Maintain fitness").tag("Maintain fitness")
                    }
                }
                
                Section {
                    Button("Save Changes") {
                        // Implement saving logic here
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
#Preview {
    ProfileView()
}
