//
//  TapeListViewModel.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import SwiftUI
import Combine

final class TapeListViewModel: ObservableObject {

    @Published var tapes: [Tape]
    @Published var algorithm: Algorithm

    private let sharedStore: AlgorithmSharedStore
    private let repository: TapeRepository

    private var cancellables = Set<AnyCancellable>()

    init(sharedStore: AlgorithmSharedStore, repository: TapeRepository) {
        self.sharedStore = sharedStore
        self.algorithm = sharedStore.algorithm
        self.tapes = sharedStore.tapes
        self.repository = repository

        setupSubscriptions()
    }

    func updateTapeHeadIndex(_ tape: Tape, newHeadIndex: Int) {
        let updatedTape = tape.copy(
            headIndex: newHeadIndex,
            workingHeadIndex: newHeadIndex
        )
        do {
            try repository.update(tape: updatedTape)
            sharedStore.fetchAlgorithm()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}

// MARK: AlgorithmShareStore subscription
extension TapeListViewModel {
    private func setupSubscriptions() {
        sharedStore.$algorithm
            .sink { [weak self] updatedAlgorithm in
                withAnimation {
                    self?.algorithm = updatedAlgorithm
                }
            }
            .store(in: &cancellables)

        sharedStore.$tapes
            .sink { [weak self] tapes in
                withAnimation {
                    self?.tapes = tapes
                }
            }
            .store(in: &cancellables)
    }
}
