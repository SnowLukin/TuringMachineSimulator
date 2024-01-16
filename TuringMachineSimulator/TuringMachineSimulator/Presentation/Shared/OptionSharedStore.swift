//
//  OptionSharedStore.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 03.01.2024.
//

import SwiftUI
import Combine

final class OptionSharedStore: ObservableObject {
    @Published var option: Option
    @Published var combinations: [Combination]

    private let optionRepository: OptionRepository
    private var cancellables = Set<AnyCancellable>()

    init(option: Option, optionRepository: OptionRepository) {
        self.option = option
        self.combinations = option.combinations
        self.optionRepository = optionRepository
    }

    func fetchOption() {
        Task { @MainActor in
            option = try await optionRepository.getOptionById(option.id)
            combinations = option.combinations
        }
    }
}
