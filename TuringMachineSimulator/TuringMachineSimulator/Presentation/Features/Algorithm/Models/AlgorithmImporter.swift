//
//  AlgorithmImporter.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation
import CoreData

struct AlgorithmImporter {

    private let repository: AlgorithmRepository

    init(repository: AlgorithmRepository) {
        self.repository = repository
    }

    func convertFrom(
        _ result: Result<URL, Error>,
        to folder: Folder
    ) throws {
        guard let selectedFileURL = try? result.get() else {
            throw ImportError.urlNotFound
        }

        if selectedFileURL.startAccessingSecurityScopedResource() {
            defer { selectedFileURL.stopAccessingSecurityScopedResource() }

            guard let data = try? Data(contentsOf: selectedFileURL) else {
                throw ImportError.dataAccessError(selectedFileURL)
            }

            guard let algorithm = try? JSONDecoder().decode(Algorithm.self, from: data) else {
                throw ImportError.decodingError
            }
            // Creating news id to avoid matching with existing instances
            let modifiedAlgorithm = updateIds(algorithm: algorithm)
            do {
                try repository.save(algorithm: modifiedAlgorithm, folder: folder)
            } catch {
                throw ImportError.other(error)
            }
        } else {
            throw ImportError.securityScopeAccessError
        }
    }

    private func updateIds(algorithm: Algorithm) -> Algorithm {
        let stateUpdatedIdsMap = Dictionary(uniqueKeysWithValues: algorithm.states.map { ($0.id, UUID().uuidString) })
        let modifiedStates = algorithm.states.map { state in
            state.copy(
                id: stateUpdatedIdsMap[state.id] ?? "",
                options: state.options.map {
                    $0.copy(
                        id: UUID().uuidString,
                        toStateId: stateUpdatedIdsMap[$0.toStateId] ?? "",
                        combinations: $0.combinations.map { $0.copy(id: UUID().uuidString) }
                    )
                }
            )
        }
        return algorithm.copy(
            id: UUID().uuidString,
            startingStateId: stateUpdatedIdsMap[algorithm.startingStateId] ?? "",
            activeStateId: stateUpdatedIdsMap[algorithm.activeStateId] ?? "",
            tapes: algorithm.tapes.map { $0.copy(id: UUID().uuidString, includePadding: false) },
            states: modifiedStates
        )
    }
}
