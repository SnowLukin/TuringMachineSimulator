//
//  AlgorithmViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 27.12.2023.
//

import SwiftUI
import Combine

final class AlgorithmViewModel: ObservableObject {

    @Published var algorithm: Algorithm
    @Published var activeStateName = "No active state"
    let sharedStore: AlgorithmSharedStore
    private let algorithmRepository: AlgorithmRepository
    private let machineStateRepository: MachineStateRepository

    let documentManager: DocumentManager

    private var autoStepTask: Task<Void, Never>?

    private var cancellables = Set<AnyCancellable>()

    init(
        sharedStore: AlgorithmSharedStore,
        algorithmRepository: AlgorithmRepository,
        machineStateRepository: MachineStateRepository
    ) {
        self.sharedStore = sharedStore
        self.algorithm = sharedStore.algorithm
        self.algorithmRepository = algorithmRepository
        self.machineStateRepository = machineStateRepository
        self.documentManager = DocumentManager(algorithm: sharedStore.algorithm)

        setupSubscriptions()
    }

    func fetchAlgorithm() {
        sharedStore.fetchAlgorithm()
    }

    func fetchActiveMachineState() {
        Task { @MainActor in
            do {
                let activeState = try await machineStateRepository.getStateBy(id: algorithm.activeStateId)
                withAnimation {
                    activeStateName = activeState.name
                }
            } catch {
                activeStateName = "No active state"
                AppLogger.error(error.localizedDescription)
            }
        }
    }

    private func updateAlgorithm(newAlgorithm: Algorithm) {
        do {
            try algorithmRepository.update(algorithm: newAlgorithm)
            fetchAlgorithm()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}

// MARK: AlgorithmSharedStore subscription
extension AlgorithmViewModel {
    private func setupSubscriptions() {
        sharedStore.$algorithm
            .sink { [weak self] updatedAlgorithm in
                withAnimation {
                    self?.algorithm = updatedAlgorithm
                    self?.fetchActiveMachineState()
                }
            }
            .store(in: &cancellables)
    }
}

extension AlgorithmViewModel {
    func startAutoSteps() {
        autoStepTask?.cancel() // Cancel any existing task before starting a new one
        autoStepTask = Task {
            while !Task.isCancelled {
                makeStep()
                try? await Task.sleep(for: .seconds(0.4))
            }
        }
    }

    func reset() {
        withAnimation {
            pauseAutoSteps()
            var resetedTapes: [Tape] = []
            for tape in algorithm.tapes {
                let updatedTape = tape.copy(
                    workingInput: tape.input,
                    workingHeadIndex: tape.headIndex,
                    includePadding: false
                )
                resetedTapes.append(updatedTape)
            }
            let updatedAlgorithm = algorithm.copy(
                activeStateId: algorithm.startingStateId,
                tapes: resetedTapes
            )
            updateAlgorithm(newAlgorithm: updatedAlgorithm)
        }
    }

    func pauseAutoSteps() {
        autoStepTask?.cancel()
        autoStepTask = nil
    }

    func makeStep() {
        // Gathering current combination
        let currentOptionCombination = getOptionCombinations()

        // Finding active State
        let activeStateId = algorithm.activeStateId
        guard let state = algorithm.states.first(where: { $0.id == activeStateId }) else {
            AppLogger.warning("Couldnt find active state.")
            return
        }

        // Finding fitting option
        guard let chosenOption = findOption(matching: currentOptionCombination, from: state) else {
            AppLogger.info("Couldn't find correct option. Skipping the step. Current state: \(state.name)")
            pauseAutoSteps()
            return
        }

        // Updated tapes array
        var tapes = algorithm.tapes

        // Performing the step changing tape components
        for index in currentOptionCombination.indices {
            guard let currentTape = algorithm.tapes.at(index) else {
                AppLogger.warning("Couldnt find tape for fromChar.")
                return
            }

            // Finding correct combination for current tape
            guard let combination = chosenOption.combinations.at(index) else {
                AppLogger.warning("Couldnt find combination for tape.")
                continue
            }

            // Checking if we can update the value in working tape input
            let headIndex = currentTape.workingHeadIndex
            if headIndex < 0 || headIndex > currentTape.workingInput.count {
                AppLogger.info("Working Head Index bigger than workingInput.")
                continue
            }

            tapes[index] = getUpdatedTape(tape: currentTape, combination: combination)
        }

        // Updating active state
        let newActiveStateId = chosenOption.toStateId
        let updatedAlgorithm = algorithm.copy(
            activeStateId: newActiveStateId,
            tapes: tapes
        )
        updateAlgorithm(newAlgorithm: updatedAlgorithm)
    }

    private func getOptionCombinations() -> [String] {
        var currentOptionCombination: [String] = []
        for tape in algorithm.tapes {
            let headIndex = tape.workingHeadIndex
            let workingInput = tape.workingInput
            let component = workingInput.at(headIndex, defaultValue: "_")
            currentOptionCombination.append(component)
        }
        return currentOptionCombination
    }

    private func findOption(matching chars: [String], from state: MachineState) -> Option? {
        state.options
            .first { $0.combinations.map { $0.fromChar } == chars }
    }

    private func getUpdatedTape(tape: Tape, combination: Combination) -> Tape {
        let workingHeadIndex = tape.workingHeadIndex
        // Updated tape's workingInput with combination's toChar
        var workingInput = tape.workingInput
        let indexForChange = workingInput.index(workingInput.startIndex, offsetBy: workingHeadIndex)
        workingInput.replaceSubrange(indexForChange...indexForChange, with: combination.toChar)
        let updatedWorkingHeadIndex = getChangedHeadIndex(
            headIndex: workingHeadIndex,
            input: workingInput,
            direction: combination.direction
        )
        return tape.copy(
            workingInput: workingInput,
            workingHeadIndex: updatedWorkingHeadIndex,
            includePadding: false
        )
    }

    private func getChangedHeadIndex(headIndex: Int, input: String, direction: Direction) -> Int {
        switch direction {
        case .stay:
            break
        case .left:
            // checking if there is room for moving head index
            if headIndex - 1 > 0 {
                return headIndex - 1
            }
        case .right:
            // checking if there is room for moving head index
            if headIndex + 1 < input.count {
                return headIndex + 1
            }
        }
        return headIndex
    }
}
