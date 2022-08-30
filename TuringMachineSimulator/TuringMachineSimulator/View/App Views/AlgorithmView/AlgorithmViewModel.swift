//
//  AlgorithmViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import Foundation

class AlgorithmViewModel: ObservableObject {
    func convertToShared(_ algorithm: Algorithm) -> AlgorithmShare {
        return AlgorithmShare(
            name: algorithm.wrappedName,
            algorithmDescription: algorithm.wrappedDescription,
            states: convertToShared(algorithm.wrappedStates),
            tapes: convertToShared(algorithm.wrappedTapes)
        )
    }
    
    private func convertToShared(_ tapes: [Tape]) -> [TapeShare] {
        var sharedTapes: [TapeShare] = []
        for tape in tapes {
            sharedTapes.append(convertToShared(tape))
        }
        return sharedTapes
    }
    
    private func convertToShared(_ tape: Tape) -> TapeShare {
        return TapeShare(
            id: tape.id,
            headIndex: tape.headIndex,
            alphabet: tape.wrappedAlphabet,
            input: tape.wrappedInput
        )
    }
    
    private func convertToShared(_ states: [StateQ]) -> [StateQShare] {
        var sharedStates: [StateQShare] = []
        for state in states {
            sharedStates.append(convertToShared(state))
        }
        return sharedStates
    }
    
    private func convertToShared(_ state: StateQ) -> StateQShare {
        return StateQShare(
            id: state.id,
            isForReset: state.isForReset,
            isStarting: state.isStarting,
            options: convertToShared(state.wrappedOptions, state: state)
        )
    }
    
    private func convertToShared(_ options: [Option], state: StateQ) -> [OptionShare] {
        var sharedOptions: [OptionShare] = []
        for option in options {
            sharedOptions.append(convertToShared(option, state: state))
        }
        return sharedOptions
    }
    
    private func convertToShared(_ option: Option, state: StateQ) -> OptionShare {
        return OptionShare(
            id: option.id,
            toStateID: option.toState?.id ?? state.id,
            combinations: convertToShared(option.wrappedCombinations)
        )
    }
    
    private func convertToShared(_ combinations: [Combination]) -> [CombinationShare] {
        var sharedCombinations: [CombinationShare] = []
        for combination in combinations {
            sharedCombinations.append(convertToShared(combination))
        }
        return sharedCombinations
    }
    
    private func convertToShared(_ combination: Combination) -> CombinationShare {
        return CombinationShare(
            id: combination.id,
            character: combination.wrappedCharacter,
            directionID: combination.direction,
            toCharacter: combination.wrappedToCharacter
        )
    }
    
}
