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

            do {
                try repository.save(algorithm: algorithm, folder: folder)
            } catch {
                throw ImportError.other(error)
            }
        } else {
            throw ImportError.securityScopeAccessError
        }
    }
}
