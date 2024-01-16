//
//  MachineStateListViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import SwiftUI
import Combine

final class MachineStateListViewModel: ObservableObject {
    private let stateRepository: MachineStateRepository
    private let algorithmRepository: AlgorithmRepository
    private var cancellables = Set<AnyCancellable>()

    @Published var states: [MachineState] = []
    @Published var algorithm: Algorithm
    @Published var searchText = ""

    var filteredStates: [MachineState] {
        searchText.isEmpty
        ? states
        : states.filter { $0.name.contains(searchText) }
    }

    init(algorithm: Algorithm, stateRepository: MachineStateRepository, algorithmRepository: AlgorithmRepository) {
        self.algorithm = algorithm
        self.stateRepository = stateRepository
        self.algorithmRepository = algorithmRepository
    }

    func fetchAlgorithm() {
        Task { @MainActor in
            do {
                let updatedAlgorithm = try await algorithmRepository.getAlgorithmBy(id: algorithm.id)
                withAnimation {
                    algorithm = updatedAlgorithm
                    states = algorithm.states
                }
            } catch {
                AppLogger.error(error.localizedDescription)
            }
        }
    }

    func createState(_ name: String) {
        let name = name.isEmpty ? "State \(states.count)" : name
        let state = MachineState(id: UUID().uuidString, name: name, options: [])
        do {
            try stateRepository.save(state: state, algorithm: algorithm)
            fetchAlgorithm()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func deleteState(_ state: MachineState) {
        do {
            try stateRepository.delete(state: state)
            fetchAlgorithm()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func updateState(_ state: MachineState) {
        do {
            try stateRepository.update(state: state)
            fetchAlgorithm()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
