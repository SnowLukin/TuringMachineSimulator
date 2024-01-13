//
//  TapeConfigListViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 02.01.2024.
//

import SwiftUI

final class TapeConfigListViewModel: ObservableObject {

    @Published var tapes: [Tape]
    @Published var algorithm: Algorithm

    private let repository: TapeRepository

    init(algorithm: Algorithm, repository: TapeRepository) {
        self.algorithm = algorithm
        self.tapes = algorithm.tapes
        self.repository = repository
    }

    func fetchTapes() {
        Task { @MainActor in
            tapes = try await repository.getTapes(algorithmId: algorithm.id)
        }
    }

    func createTape(_ name: String) {
        let name = name.isEmpty ? "Tape \(tapes.count)" : name
        let tape = Tape(name: name)
        do {
            try repository.save(tape: tape, algorithm: algorithm)
            fetchTapes()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func deleteTape(_ tape: Tape) {
        do {
            try repository.delete(tape: tape)
            fetchTapes()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func updateTapeWithInput(_ tape: Tape, newInput: String) {
        let trimmedInput = newInput.trim("_")
        let updatedTape = tape.copyUpdated(
            input: trimmedInput,
            workingInput: trimmedInput
        )
        do {
            try repository.update(tape: updatedTape)
            fetchTapes()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
