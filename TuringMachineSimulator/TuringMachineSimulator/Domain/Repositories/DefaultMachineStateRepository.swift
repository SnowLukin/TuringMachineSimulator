//
//  DefaultMachineStateRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import Foundation
import Combine
import CoreData

final class DefaultMachineStateRepository: MachineStateRepository {

    private let persistentContainer: NSPersistentContainer
    private let optionRepository: OptionRepository

    init(persistentContainer: NSPersistentContainer, optionRepository: OptionRepository) {
        self.persistentContainer = persistentContainer
        self.optionRepository = optionRepository
    }

    func getStates(algorithmId: String) async throws -> [MachineState] {
        let algorithmRequest = CDAlgorithm.fetchRequest()
        algorithmRequest.predicate = NSPredicate(format: "id == %@", algorithmId)

        let context = persistentContainer.viewContext

        let fetchedAlgorithms = try context.performAndWait {
            try context.fetch(algorithmRequest)
        }
        guard let algorithm = fetchedAlgorithms.first else {
            throw CDError.errorWithMessage("Failed getting folder with id: \"\(algorithmId)\"")
        }
        return algorithm.unwrappedStates.map { MachineState(entity: $0) }
    }

    func getStateBy(id: String) async throws -> MachineState {
        let context = persistentContainer.viewContext

        let request = CDMachineState.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        let entities = try context.performAndWait {
            try context.fetch(request)
        }
        guard let entity = entities.first else {
            throw CDError.errorWithMessage("No machine state with id: \"\(id)\".")
        }
        return MachineState(entity: entity)
    }

    func update(state: MachineState) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDMachineState.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", state.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToUpdate = results.first {
                entityToUpdate.name = state.name

                // Deleting unused options
                let updatedOptionsIds = Set(state.options.map { $0.id })
                for entity in entityToUpdate.unwrappedOptions {
                    guard let id = entity.id, updatedOptionsIds.contains(id) else {
                        entityToUpdate.removeFromOptions(entity)
                        let option = Option(entity: entity)
                        try optionRepository.delete(option: option)
                        continue
                    }
                }

                // Creating/Updating existing states
                let existingOptionsIds = Set(entityToUpdate.unwrappedOptions.compactMap { $0.id })
                try state.options.forEach { option in
                    if !existingOptionsIds.contains(option.id) {
                        try optionRepository.save(option: option, state: state)
                    } else {
                        try optionRepository.update(option: option)
                    }
                }

                try context.save()
            }
        }
    }

    func delete(state: MachineState) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDMachineState.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", state.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
            }
        }
    }

    func save(state: MachineState, algorithm: Algorithm) throws {
        let context = persistentContainer.viewContext

        let algorithmRequest = CDAlgorithm.fetchRequest()
        algorithmRequest.predicate = NSPredicate(format: "id == %@", algorithm.id)
        algorithmRequest.fetchLimit = 1

        guard let algorithmEntity = try context.fetch(algorithmRequest).first else {
            throw CDError.errorWithMessage("Failed to find algorithm with id: \(algorithm.id)")
        }

        let existingStates = Set(algorithmEntity.unwrappedStates.map { $0.id })

        if !existingStates.contains(state.id) {
            let stateEntity = CDMachineState(context: context)
            stateEntity.id = state.id
            stateEntity.name = state.name

            try state.options.forEach { option in
                try optionRepository.save(option: option, state: state)
            }
            algorithmEntity.addToStates(stateEntity)
        }
        try context.save()
    }
}
