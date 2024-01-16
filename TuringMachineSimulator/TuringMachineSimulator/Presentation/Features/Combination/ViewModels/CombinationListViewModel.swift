//
//  CombinationListViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import SwiftUI
import Combine

final class CombinationListViewModel: ObservableObject {

    @Published var combinations: [Combination]

    private let sharedStore: OptionSharedStore
    private let repository: CombinationRepository
    private var cancellables = Set<AnyCancellable>()

    init(sharedStore: OptionSharedStore, repository: CombinationRepository) {
        self.sharedStore = sharedStore
        self.combinations = sharedStore.combinations
        self.repository = repository

        setupSubscriptions()
    }

    func deleteCombination(_ combination: Combination) {
        do {
            try repository.delete(combination: combination)
            sharedStore.fetchOption()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func updateCombination(_ combination: Combination) {
        do {
            try repository.update(combination: combination)
            sharedStore.fetchOption()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}

// MARK: OptionSharedStore subscription
extension CombinationListViewModel {
    func setupSubscriptions() {
        sharedStore.$combinations
            .sink { [weak self] updatedCombinations in
                withAnimation {
                    self?.combinations = updatedCombinations
                }
            }
            .store(in: &cancellables)
    }
}
