//
//  TuringMachineSimulatorApp.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 23.08.2022.
//

import SwiftUI

@main
struct TuringMachineSimulatorApp: App {

    init() {
        Resolver.shared.injectModules()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
