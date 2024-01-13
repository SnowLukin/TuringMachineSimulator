//
//  DefaultTapeRepository.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import Foundation
import Combine
import CoreData

final class DefaultTapeRepository: TapeRepository {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func getTapes(algorithmId: String) async throws -> [Tape] {
        let algorithmRequest = CDAlgorithm.fetchRequest()
        algorithmRequest.predicate = NSPredicate(format: "id == %@", algorithmId)

        let context = persistentContainer.viewContext

        let fetchedAlgorithms = try context.performAndWait {
            try context.fetch(algorithmRequest)
        }
        guard let algorithm = fetchedAlgorithms.first else {
            throw CDError.errorWithMessage("Failed getting algorithm with id: \(algorithmId)")
        }
        return algorithm.unwrappedTapes.map { Tape(entity: $0) }
    }

    func getTapeById(_ id: String) async throws -> Tape {
        let request = CDTape.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        let context = persistentContainer.viewContext

        let fetchedTapes = try context.performAndWait {
            try context.fetch(request)
        }
        guard let tapeEntity = fetchedTapes.first else {
            throw CDError.errorWithMessage("Couldn't find tape with id: \"\(id)\"")
        }
        return Tape(entity: tapeEntity)
    }

    func update(tape: Tape) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDTape.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tape.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToUpdate = results.first {
                entityToUpdate.name = tape.name
                entityToUpdate.headIndex = Int64(tape.headIndex)
                entityToUpdate.workingHeadIndex = Int64(tape.workingHeadIndex)
                entityToUpdate.input = tape.input
                entityToUpdate.workingInput = tape.workingInput
                try context.save()
            }
        }
    }

    func delete(tape: Tape) throws {
        let context = persistentContainer.newBackgroundContext()
        let request = CDTape.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tape.id)

        try context.performAndWait {
            let results = try request.execute()

            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
            }
        }
    }

    func save(tape: Tape, algorithm: Algorithm) throws {
        let context = persistentContainer.viewContext

        let algorithmRequest = CDAlgorithm.fetchRequest()
        algorithmRequest.predicate = NSPredicate(format: "id == %@", algorithm.id)
        algorithmRequest.fetchLimit = 1

        guard let algorithmEntity = try context.fetch(algorithmRequest).first else {
            throw CDError.errorWithMessage("Failed to find algorithm with id: \(algorithm.id)")
        }

        let existingTapes = algorithmEntity.unwrappedTapes

        if !existingTapes.contains(where: { $0.id == tape.id }) {
            let tapeEntity = CDTape(context: context)
            tapeEntity.id = tape.id
            tapeEntity.name = tape.name
            tapeEntity.input = tape.input
            tapeEntity.workingInput = tape.workingInput
            tapeEntity.headIndex = Int64(tape.headIndex)
            tapeEntity.workingHeadIndex = Int64(tape.workingHeadIndex)
            algorithmEntity.addToTapes(tapeEntity)
        }
        try context.save()
    }
}
