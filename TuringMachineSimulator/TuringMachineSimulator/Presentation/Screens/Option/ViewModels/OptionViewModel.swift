//
//  OptionViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 26.12.2023.
//

import SwiftUI
import Combine

final class OptionViewModel: ObservableObject {

    @Published var option: Option
    @Published var algorithm: Algorithm
    @Published var destinationStateName = "Not found"

    let sharedStore: OptionSharedStore
    private let combinationRepository: CombinationRepository

    private var cancellables = Set<AnyCancellable>()

//    var destinationStateName: String {
//        algorithm.states
//            .filter { $0.id == option.toStateId }
//            .first?.name ?? "Not found"
//    }

    init(
        sharedStore: OptionSharedStore,
        algorithm: Algorithm,
        combinationRepository: CombinationRepository
    ) {
        self.option = sharedStore.option
        self.algorithm = algorithm
        self.sharedStore = sharedStore
        self.combinationRepository = combinationRepository

        setupSubscriptions()
    }

    func setupSubscriptions() {
        sharedStore.$option
            .sink { [weak self] updatedOption in
                withAnimation {
                    self?.option = updatedOption
                    self?.destinationStateName = self?.algorithm.states
                        .filter { $0.id == updatedOption.toStateId }
                        .first?.name ?? "Not found"
                }
            }
            .store(in: &cancellables)
    }

    func fetchOption() {
        sharedStore.fetchOption()
    }

    func createCombination() {
        let combination = Combination(fromChar: "-")
        do {
            try combinationRepository.save(combination: combination, option: option)
            sharedStore.fetchOption()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
