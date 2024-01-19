//
//  FakeAlgorithmRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

final class FakeAlgorithmRepository: AlgorithmRepository {

    private var algorithms: [Algorithm]

    init(algorithms: [Algorithm] = Algorithm.samples) {
        self.algorithms = algorithms
    }

    func getAlgorithms(folderId: String) async throws -> [Algorithm] {
        algorithms
    }

    func getAlgorithmBy(id: String) async throws -> Algorithm {
        algorithms.first ?? Algorithm.sample
    }

    func update(algorithm: Algorithm) throws {
        if let index = algorithms.firstIndex(where: { $0.id == algorithm.id }) {
            algorithms[index] = algorithm
        } else {
            throw CDError.errorWithMessage("Algorithm not found")
        }
    }

    func delete(algorithm: Algorithm) throws {
        algorithms.removeAll { $0.id == algorithm.id }
    }

    func save(algorithm: Algorithm, folder: Folder) throws {
        if !self.algorithms.contains(where: { $0.id == algorithm.id }) {
            self.algorithms.append(algorithm)
        }
    }
}
