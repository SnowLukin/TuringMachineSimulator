//
//  DefaultAlgorithmRepository.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import Foundation
import CoreData

final class DefaultAlgorithmRepository: AlgorithmRepository {

    private let persistentContainer: NSPersistentContainer
    private let tapeRepository: TapeRepository
    private let machineStateRepository: MachineStateRepository

    init(persistentContainer: NSPersistentContainer,
         tapeRepository: TapeRepository,
         machineStateRepository: MachineStateRepository
    ) {
        self.persistentContainer = persistentContainer
        self.tapeRepository = tapeRepository
        self.machineStateRepository = machineStateRepository
    }

    func getAlgorithms(folderId: String) async throws -> [Algorithm] {
        let folderRequest = CDFolder.fetchRequest()
        folderRequest.predicate = NSPredicate(format: "id == %@", folderId)

        let context = persistentContainer.viewContext

        let folderEntities = try context.performAndWait {
            try context.fetch(folderRequest)
        }

        guard let folder = folderEntities.first else {
            throw CDError.errorWithMessage("Failed getting folder with id: \(folderId)")
        }
        let algorithmRequest = CDAlgorithm.fetchRequest()
        algorithmRequest.predicate = NSPredicate(format: "folder == %@", folder)

        let algorithmEntities = try await context.perform {
            try context.fetch(algorithmRequest)
        }

        let algorithms = algorithmEntities.map { Algorithm(entity: $0) }
        return algorithms
    }

    func getAlgorithmBy(id: String) async throws -> Algorithm {
        let context = persistentContainer.viewContext
        let request = CDAlgorithm.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let entities = try context.performAndWait {
            try context.fetch(request)
        }
        guard let entity = entities.first else {
            throw CDError.errorWithMessage("No algorithm with id \(id) found.")
        }
        let algorithm = Algorithm(entity: entity)
        return algorithm
    }

    func update(algorithm: Algorithm) throws {
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<CDAlgorithm> = CDAlgorithm.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", algorithm.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToUpdate = results.first {
                entityToUpdate.name = algorithm.name
                entityToUpdate.activeStateId = algorithm.activeStateId
                entityToUpdate.startingStateId = algorithm.startingStateId
                entityToUpdate.algDescription = algorithm.algDescription
                entityToUpdate.createdDate = algorithm.createdDate
                entityToUpdate.lastEditDate = algorithm.lastEditDate

                // Deleting unused tapes
                let updatedTapesIds = Set(algorithm.tapes.map { $0.id })
                for tapeEntity in entityToUpdate.unwrappedTapes {
                    guard let id = tapeEntity.id, updatedTapesIds.contains(id) else {
                        entityToUpdate.removeFromTapes(tapeEntity)
                        let tape = Tape(entity: tapeEntity)
                        try tapeRepository.delete(tape: tape)
                        continue
                    }
                }

                // Creating/Updating existing tapes
                let existingTapesIds = Set(entityToUpdate.unwrappedTapes.compactMap { $0.id })
                try algorithm.tapes.forEach { tape in
                    if !existingTapesIds.contains(tape.id) {
                        try tapeRepository.save(tape: tape, algorithm: algorithm)
                    } else {
                        try tapeRepository.update(tape: tape)
                    }
                }

                // Deleting unused states
                let updatedStatesIds = Set(algorithm.states.map { $0.id })
                for entity in entityToUpdate.unwrappedStates {
                    guard let id = entity.id, updatedStatesIds.contains(id) else {
                        entityToUpdate.removeFromStates(entity)
                        let state = MachineState(entity: entity)
                        try machineStateRepository.delete(state: state)
                        continue
                    }
                }

                // Creating/Updating existing states
                let existingStatesIds = Set(entityToUpdate.unwrappedStates.compactMap { $0.id })
                try algorithm.states.forEach { state in
                    if !existingStatesIds.contains(state.id) {
                        try machineStateRepository.save(state: state, algorithm: algorithm)
                    } else {
                        try machineStateRepository.update(state: state)
                    }
                }

                try context.save()
            }
        }
    }

    func delete(algorithm: Algorithm) throws {
        let context = persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<CDAlgorithm> = CDAlgorithm.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", algorithm.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
            }
        }
    }

    func save(algorithm: Algorithm, folder: Folder) throws {

        let context = persistentContainer.viewContext

        let folderRequest = CDFolder.fetchRequest()
        folderRequest.predicate = NSPredicate(format: "id == %@", folder.id)
        folderRequest.fetchLimit = 1

        guard let folderEntity = try context.fetch(folderRequest).first else {
            throw CDError.errorWithMessage("Failed to find folder with id: \(folder.id)")
        }

        let existingAlgorithms = folderEntity.unwrappedAlgorithms

        if !existingAlgorithms.contains(where: { $0.id == algorithm.id }) {
            let algorithmEntity = CDAlgorithm(context: context)
            algorithmEntity.id = algorithm.id
            algorithmEntity.name = algorithm.name
            algorithmEntity.algDescription = algorithm.algDescription
            algorithmEntity.activeStateId = algorithm.activeStateId
            algorithmEntity.startingStateId = algorithm.startingStateId
            algorithmEntity.lastEditDate = algorithm.lastEditDate
            algorithmEntity.createdDate = algorithm.createdDate

            try algorithm.tapes.forEach { tape in
                try tapeRepository.save(tape: tape, algorithm: algorithm)
            }

            try algorithm.states.forEach { state in
                try machineStateRepository.save(state: state, algorithm: algorithm)
            }

            folderEntity.addToAlgorithms(algorithmEntity)
        }
        try context.save()
    }
}
