//
//  TuringMachineSimulatorApp.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 23.08.2022.
//

import SwiftUI

@main
struct TuringMachineSimulatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
