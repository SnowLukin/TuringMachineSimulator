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

    @Published var showLoader = false

    var filteredAlgorithms: [Algorithm] {
        searchText.isEmpty
        ? algorithms
        : algorithms.filter { $0.name.contains(searchText) }
    }

    private let repository: AlgorithmRepository
    private let algorithmImporter: AlgorithmImporter

    init(folder: Folder, repository: AlgorithmRepository) {
        self.folder = folder
        self.repository = repository
        self.algorithmImporter = AlgorithmImporter(repository: repository)
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

    func importAlgorithm(_ result: Result<URL, Error>) {
        withAnimation {
            showLoader = true
        }
        do {
            try algorithmImporter.convertFrom(result, to: folder)
            withAnimation {
                fetchAlgorithms()
                showLoader = false
            }
            AppLogger.info("Algorithm imported successfully.")
        } catch {
            AppLogger.error(error.localizedDescription)
            withAnimation {
                showLoader = false
            }
        }
    }
}
