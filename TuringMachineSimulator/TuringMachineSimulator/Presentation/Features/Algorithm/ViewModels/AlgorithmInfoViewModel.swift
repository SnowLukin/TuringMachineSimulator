//
//  AlgorithmInfoViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 18.01.2024.
//

import SwiftUI

final class AlgorithmInfoViewModel: ObservableObject {
    @Published var algorithm: Algorithm

    private let repository: AlgorithmRepository

    init(algorithm: Algorithm, repository: AlgorithmRepository) {
        self.algorithm = algorithm
        self.repository = repository
    }

    func fetchAlgorithm() {
        Task { @MainActor in
            algorithm = try await repository.getAlgorithmBy(id: algorithm.id)
        }
    }

    func updateName(_ name: String) {
        let updatedAlgorithm = algorithm.copy(name: name)
        updateAlgorithm(updatedAlgorithm)
    }

    func updateDescription(_ description: String) {
        let updatedAlgorithm = algorithm.copy(algDescription: description)
        updateAlgorithm(updatedAlgorithm)
    }

    private func updateAlgorithm(_ updatedAlgorithm: Algorithm) {
        do {
            try repository.update(algorithm: updatedAlgorithm)
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
