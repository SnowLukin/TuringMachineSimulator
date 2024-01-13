//
//  AlgorithmListScreenViewModel.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import SwiftUI

final class AlgorithmListScreenViewModel: ObservableObject {

    @Published var folder: Folder
    @Published var algorithms: [Algorithm] = []
    @Published var searchText = ""

    var filteredAlgorithms: [Algorithm] {
        searchText.isEmpty
        ? algorithms
        : algorithms.filter { $0.name.contains(searchText) }
    }

    private let repository: AlgorithmRepository

    init(folder: Folder, repository: AlgorithmRepository) {
        self.folder = folder
        self.repository = repository
    }

    func fetchAlgorithms() {
        Task { @MainActor in
            do {
                algorithms = try await repository.getAlgorithms(folderId: folder.id)
            } catch {
                AppLogger.error(error.localizedDescription)
            }
        }
    }

    func createAlgorithm(_ name: String) {
        let name = name.isEmpty ? "New Algorithm" : name
        let algorithm = Algorithm(name: name)
        do {
            try repository.save(algorithm: algorithm, folder: folder)
            fetchAlgorithms()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func deleteAlgorithm(_ algorithm: Algorithm) {
        do {
            try repository.delete(algorithm: algorithm)
            fetchAlgorithms()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
