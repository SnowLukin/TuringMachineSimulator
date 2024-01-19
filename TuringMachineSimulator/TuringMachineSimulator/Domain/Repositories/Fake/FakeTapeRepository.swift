//
//  FakeTapeRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

final class FakeTapeRepository: TapeRepository {

    private var tapes: [Tape]

    init(tapes: [Tape] = Tape.samples) {
        self.tapes = tapes
    }

    func getTapes(algorithmId: String) async throws -> [Tape] {
        tapes
    }

    func getTapeById(_ id: String) async throws -> Tape {
        tapes.first(where: { $0.id == id }) ?? Tape.sample
    }

    func update(tape: Tape) throws {
        if let index = tapes.firstIndex(where: { $0.id == tape.id }) {
            tapes[index] = tape
        } else {
            throw CDError.errorWithMessage("Tape not found")
        }
    }

    func delete(tape: Tape) throws {
        tapes.removeAll { $0.id == tape.id }
    }

    func save(tape: Tape, algorithm: Algorithm) throws {
        if !self.tapes.contains(where: { $0.id == tape.id }) {
            self.tapes.append(tape)
        }
    }
}
