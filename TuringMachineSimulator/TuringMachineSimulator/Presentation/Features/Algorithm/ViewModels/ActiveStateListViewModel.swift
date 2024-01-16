//
//  ActiveStateListViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 28.12.2023.
//

import SwiftUI

final class ActiveStateListViewModel: ObservableObject {
    @Published var algorithm: Algorithm

    private let repository: AlgorithmRepository

    init(algorithm: Algorithm, repository: AlgorithmRepository) {
        self.algorithm = algorithm
        self.repository = repository
    }

    func fetchAlgorithm() {
        Task { @MainActor in
            do {
                algorithm = try await repository.getAlgorithmBy(id: algorithm.id)
            } catch {
                AppLogger.error(error.localizedDescription)
            }
        }
    }

    func selectActiveState(_ state: MachineState) {
        let updatedAlgorithm = algorithm.copy(startingStateId: state.id, activeStateId: state.id)
        do {
            try repository.update(algorithm: updatedAlgorithm)
            fetchAlgorithm()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
