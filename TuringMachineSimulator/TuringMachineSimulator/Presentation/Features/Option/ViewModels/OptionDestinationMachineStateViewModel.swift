//
//  OptionDestinationMachineStateViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 24.12.2023.
//

import SwiftUI
import Combine

final class OptionDestinationMachineStateViewModel: ObservableObject {

    @Published var option: Option
    @Published var algorithm: Algorithm
    @Published var states: [MachineState] = []
    @Published var destinationStateId: String

    private let optionRepository: OptionRepository
    private let stateRepository: MachineStateRepository

    private var cancellables = Set<AnyCancellable>()

    init(
        option: Option,
        algorithm: Algorithm,
        optionRepository: OptionRepository,
        stateRepository: MachineStateRepository
    ) {
        self.option = option
        self.algorithm = algorithm
        self.optionRepository = optionRepository
        self.stateRepository = stateRepository
        self.destinationStateId = option.toStateId
    }

    func fetchStates() {
        Task { @MainActor in
            do {
                let updatedStates = try await stateRepository.getStates(algorithmId: algorithm.id)
                withAnimation {
                    states = updatedStates
                }
            } catch {
                AppLogger.error(error.localizedDescription)
            }
        }
    }

    func updateDestinationState(stateId: String) {
        let updatedOption = option.copy(toStateId: stateId)
        do {
            try optionRepository.update(option: updatedOption)
            destinationStateId = stateId
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
