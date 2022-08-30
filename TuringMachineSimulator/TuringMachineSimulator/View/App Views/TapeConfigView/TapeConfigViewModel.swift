//
//  TapeConfigViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 25.08.2022.
//

import SwiftUI
import CoreData

class TapeConfigViewModel: ObservableObject {
    
    private func addOptions(to state: StateQ, combinations: [[String]], viewContext: NSManagedObjectContext) {
        for combinationIndex in 0..<combinations.count {
            let option = Option(context: viewContext)
            option.id = Int64(combinationIndex)
            
            //
            state.addToOptions(option)
            state.addToFromOptions(option)
            
            addCombinations(combinations: combinations[combinationIndex], option: option, viewContext: viewContext)
        }
    }
    
    private func addCombinations(combinations: [String], option: Option, viewContext: NSManagedObjectContext) {
        for combinationIndex in 0..<combinations.count {
            let combination = Combination(context: viewContext)
            combination.id = Int64(combinationIndex)
            combination.character = combinations[combinationIndex]
            combination.direction = 0
            combination.toCharacter = combinations[combinationIndex]
            
            option.addToCombinations(combination)
        }
    }
    
    private func getTapesAlphabets(of algorithm: Algorithm) -> [[String]] {
        var alphabets: [[String]] = []
        for tape in algorithm.wrappedTapes {
            var tapeAlphabet = tape.wrappedAlphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        return alphabets
    }
    
    private func getCombinations(array: [[String]], word: [String], currentArrayIndex: Int, result: inout [[String]]) {
        if currentArrayIndex == array.count {
            result.append(word)
        } else {
            for element in array[currentArrayIndex] {
                var newWord = word
                newWord.append(element)
                getCombinations(array: array, word: newWord, currentArrayIndex: currentArrayIndex + 1, result: &result)
            }
        }
    }
    
    private func getPossibleCombinations(for state: StateQ) -> [[String]] {
        guard let algorithm = state.algorithm else {
            print("Failed getting algorithm from state in func getPossibleCombinations()")
            return []
        }
        let alphabets: [[String]] = getTapesAlphabets(of: algorithm)
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        return combinations
    }
    
    private func updateStates(for algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        for state in algorithm.wrappedStates {
            for option in state.wrappedOptions {
                state.removeFromOptions(option)
                viewContext.delete(option)
            }
            let combinations = getPossibleCombinations(for: state)
            addOptions(to: state, combinations: combinations, viewContext: viewContext)
        }
        algorithm.editDate = Date.now
    }
    
    func deleteTape(_ tape: Tape, viewContext: NSManagedObjectContext) {
        guard let algorithm = tape.algorithm else {
            print("Failed getting algorithm from tape")
            return
        }
        algorithm.removeFromTapes(tape)
        viewContext.delete(tape)
        updateStates(for: algorithm, viewContext: viewContext)
        
        do {
            try viewContext.save()
            print("Tape deletion saved successfully.")
        } catch {
            print("Failed saving tape deletion.")
            print(error.localizedDescription)
        }
    }
}
