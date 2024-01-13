//
//  DefaultOptionRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import Foundation
import Combine
import CoreData

final class DefaultOptionRepository: OptionRepository {

    private let persistentContainer: NSPersistentContainer
    private let combinationRepository: CombinationRepository

    init(persistentContainer: NSPersistentContainer, combinationRepository: CombinationRepository) {
        self.persistentContainer = persistentContainer
        self.combinationRepository = combinationRepository
    }

    func getOptions(stateId: String) async throws -> [Option] {
        let stateRequest = CDMachineState.fetchRequest()
        stateRequest.predicate = NSPredicate(format: "id == %@", stateId)

        let context = persistentContainer.viewContext

        let fetchedStates = try context.performAndWait {
            try context.fetch(stateRequest)
        }
        guard let state = fetchedStates.first else {
            throw CDError.errorWithMessage("Failed getting state with id: \(stateId)")
        }
        return state.unwrappedOptions.map { Option(entity: $0) }
    }

    func getOptionById(_ id: String) async throws -> Option {
        let context = persistentContainer.viewContext
        let optionRequest = CDOption.fetchRequest()
        optionRequest.predicate = NSPredicate(format: "id == %@", id)

        let entities = try context.performAndWait {
            try context.fetch(optionRequest)
        }
        guard let entity = entities.first else {
            throw CDError.errorWithMessage("No option with id \(id).")
        }
        return Option(entity: entity)
    }

    func update(option: Option) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDOption.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", option.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToUpdate = results.first {
                entityToUpdate.toStateId = option.toStateId

                // Deleting unused options
                let updatedCombinationsIds = Set(option.combinations.map { $0.id })
                for entity in entityToUpdate.unwrappedCombinations {
                    guard let id = entity.id, updatedCombinationsIds.contains(id) else {
                        entityToUpdate.removeFromCombinations(entity)
                        let combination = Combination(entity: entity)
                        try combinationRepository.delete(combination: combination)
                        continue
                    }
                }

                // Creating/Updating existing states
                let existingCombinationsIds = Set(entityToUpdate.unwrappedCombinations.compactMap { $0.id })
                try option.combinations.forEach { combination in
                    if !existingCombinationsIds.contains(combination.id) {
                        try combinationRepository.save(combination: combination, option: option)
                    } else {
                        try combinationRepository.update(combination: combination)
                    }
                }

                try context.save()
            }
        }
    }

    func delete(option: Option) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDOption.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", option.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
            }
        }
    }

    func save(option: Option, state: MachineState) throws {
        let context = persistentContainer.viewContext

        let stateRequest = CDMachineState.fetchRequest()
        stateRequest.predicate = NSPredicate(format: "id == %@", state.id)
        stateRequest.fetchLimit = 1

        guard let stateEntity = try context.fetch(stateRequest).first else {
            throw CDError.errorWithMessage("Failed to find state with id: \(state.id)")
        }

        let existingOptions = Set(stateEntity.unwrappedOptions.compactMap { $0.id })

        if !existingOptions.contains(option.id) {
            let optionEntity = CDOption(context: context)
            optionEntity.id = option.id
            optionEntity.toStateId = option.toStateId
            try option.combinations.forEach { combination in
                try combinationRepository.save(combination: combination, option: option)
            }
            stateEntity.addToOptions(optionEntity)
        }
        try context.save()
    }
}
