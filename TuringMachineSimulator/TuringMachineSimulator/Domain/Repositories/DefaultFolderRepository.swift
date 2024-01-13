//
//  DefaultFolderRepository.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import Foundation
import CoreData

final class DefaultFolderRepository: FolderRepository {

    private let persistentContainer: NSPersistentContainer
    private let algorithmRepository: AlgorithmRepository

    init(persistentContainer: NSPersistentContainer, algorithmRepository: AlgorithmRepository) {
        self.persistentContainer = persistentContainer
        self.algorithmRepository = algorithmRepository
    }

    func getFolders() async throws -> [Folder] {
        let request = CDFolder.fetchRequest()
        let context = persistentContainer.viewContext

        let folderEntities = try await context.perform {
            try context.fetch(request)
        }
        let folders = folderEntities.map { Folder(entity: $0) }
        return folders
    }

    func update(folder: Folder) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDFolder.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", folder.id)
        request.fetchLimit = 1

        try context.performAndWait {
            let results = try request.execute()
            guard let entityToUpdate = results.first else {
                throw CDError.errorWithMessage("Couldn't find folder with id: \"\(folder.id)\"")
            }
            entityToUpdate.name = folder.name

            // Algorithms that was in folder before update
            let existingAlgorithmsIds = Set(entityToUpdate.unwrappedAlgorithms.compactMap { $0.id })
            // Ids of algorithms that are present in updated folder
            let updatedAlgorithmsIds = Set(folder.algorithms.map { $0.id })

            // Removing the deleted algorithms
            for algorithmEntity in entityToUpdate.unwrappedAlgorithms {
                guard let algorithmId = algorithmEntity.id, updatedAlgorithmsIds.contains(algorithmId) else {
                    entityToUpdate.removeFromAlgorithms(algorithmEntity)
                    try algorithmRepository.delete(algorithm: Algorithm(entity: algorithmEntity))
                    continue
                }
            }

            // Creating/Updating new algorithms if they are not added to folder yet
            try folder.algorithms.forEach { algorithm in
                if !existingAlgorithmsIds.contains(algorithm.id) {
                    try algorithmRepository.save(algorithm: algorithm, folder: folder)
                } else {
                    try algorithmRepository.update(algorithm: algorithm)
                }
            }
            try context.save()
        }
    }

    func delete(folder: Folder) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDFolder.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", folder.id)
        request.fetchLimit = 1

        try context.performAndWait {
            let results = try request.execute()

            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
            }
        }
    }

    func save(_ folder: Folder) throws {
        let context = persistentContainer.viewContext
        let request = CDFolder.fetchRequest()
        let existingEntities = try context.fetch(request)
        let existingIds = Set(existingEntities.compactMap { $0.id })

        if !existingIds.contains(folder.id) {
            let entity = CDFolder(context: context)
            entity.id = folder.id
            entity.name = folder.name
            entity.algorithms = []
            for algorithm in folder.algorithms {
                try algorithmRepository.save(algorithm: algorithm, folder: folder)
            }
        }
        try context.save()
    }
}
