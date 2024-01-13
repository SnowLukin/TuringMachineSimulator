//
//  Coordinator.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import SwiftUI

final class Coordinator: ObservableObject {

    @Published var path = NavigationPath()

    func push(_ page: Page) {
        path.append(page)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .folderList:
            FolderListScreen()
        case .folder(let folder):
            AlgorithmListScreen(folder: folder)
        case .algorithm(let algorithm):
            AlgorithmScreen(algorithm: algorithm)
        case .tapeConfig(let algorithm):
            TapeConfigListView(algorithm: algorithm)
        case .stateList(let algorithm):
            MachineStateListView(algorithm: algorithm)
        case .optionList(let machineState, let algorithm):
            OptionListView(state: machineState, algorithm: algorithm)
        case .option(let option, let algorithm):
            OptionView(option: option, algorithm: algorithm)
        case .optionDestinationState(let option, let algorithm):
            OptionDestinationMachineStateView(option: option, algorithm: algorithm)
        case .activeStateList(let algorithm):
            ActiveStateListView(algorithm: algorithm)
        }
    }
}
