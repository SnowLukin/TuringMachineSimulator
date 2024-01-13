//
//  DefaultCombinationRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import Foundation
import Combine
import CoreData

final class DefaultCombinationRepository: CombinationRepository {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func getCombinations(optionId: String) async throws -> [Combination] {
        let optionRequest = CDOption.fetchRequest()
        optionRequest.predicate = NSPredicate(format: "id == %@", optionId)

        let context = persistentContainer.viewContext

        let fetchedOptions = try context.performAndWait {
            try context.fetch(optionRequest)
        }
        guard let option = fetchedOptions.first else {
            throw CDError.errorWithMessage("Failed getting option with id: \(optionId)")
        }
        return option.unwrappedCombinations.map { Combination(entity: $0) }
    }

    func update(combination: Combination) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDCombination.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", combination.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToUpdate = results.first {
                entityToUpdate.fromChar = combination.fromChar
                entityToUpdate.directionIndex = Int64(combination.direction.intValue)
                entityToUpdate.toChar = combination.toChar
                try context.save()
            }
        }
    }

    func delete(combination: Combination) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDCombination.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", combination.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
            }
        }
    }

    func save(combination: Combination, option: Option) throws {
        let context = persistentContainer.viewContext

        let optionRequest = CDOption.fetchRequest()
        optionRequest.predicate = NSPredicate(format: "id == %@", option.id)
        optionRequest.fetchLimit = 1

        guard let optionEntity = try context.fetch(optionRequest).first else {
            throw CDError.errorWithMessage("Failed to find option with id: \(option.id)")
        }

        let existingCombinations = Set(optionEntity.unwrappedCombinations.compactMap { $0.id })

        if !existingCombinations.contains(combination.id) {
            let combinationEntity = CDCombination(context: context)
            combinationEntity.id = combination.id
            combinationEntity.fromChar = combination.fromChar
            combinationEntity.toChar = combination.toChar
            combinationEntity.directionIndex = Int64(combination.direction.intValue)
            optionEntity.addToCombinations(combinationEntity)
        }
        try context.save()
    }
}
