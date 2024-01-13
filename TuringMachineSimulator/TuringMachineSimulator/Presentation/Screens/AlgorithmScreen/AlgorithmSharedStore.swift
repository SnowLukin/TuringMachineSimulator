//
//  AlgorithmSharedStore.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 02.01.2024.
//

import Foundation

final class AlgorithmSharedStore: ObservableObject {
    @Published var algorithm: Algorithm
    @Published var tapes: [Tape]

    private let repository: AlgorithmRepository

    init(algorithm: Algorithm, repository: AlgorithmRepository) {
        self.algorithm = algorithm
        self.tapes = algorithm.tapes
        self.repository = repository
    }

    func fetchAlgorithm() {
        Task { @MainActor in
            do {
                algorithm = try await repository.getAlgorithmBy(id: algorithm.id)
                tapes = algorithm.tapes
            } catch {
                AppLogger.error(error.localizedDescription)
            }
        }
    }
}
