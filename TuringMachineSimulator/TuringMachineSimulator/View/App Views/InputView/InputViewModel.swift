//
//  InputViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 25.08.2022.
//

import SwiftUI
import CoreData

class InputViewModel: ObservableObject {
    
    private func addOptions(to state: StateQ, combinations: [[String]], viewContext: NSManagedObjectContext) {
        for combinationIndex in 0..<combinations.count {
            let option = Option(context: viewContext)
            option.id = Int64(combinationIndex)
            
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
            combination.toCharacter = combinations[combinationIndex]
            combination.direction = 0
            
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
    
    private func updateAlphabet(_ text: String, for tape: Tape, viewContext: NSManagedObjectContext) {
        guard let algorithm = tape.algorithm else  {
            print("Failed getting algorithm from tape")
            return
        }
        tape.alphabet = text
        updateStates(for: algorithm, viewContext: viewContext)
        algorithm.editDate = Date.now
    }
    
    private func removeInputCharactersWhichAreNotInAlphabet(for tape: Tape) {
        let filteredInput = tape.wrappedInput.filter { tape.wrappedAlphabet.contains($0)}
        updateInput(filteredInput, for: tape)
    }
    
    private func updateInput(_ text: String, for tape: Tape) {
        tape.input = text
        updateComponents(for: tape)
        
        tape.algorithm?.editDate = Date.now
    }
    
    private func updateComponents(for tape: Tape) {
        // Update components values according to input
        for component in tape.wrappedComponents {
            if (0..<tape.wrappedInput.count).contains(component.wrappedID) {
                component.value = tape.wrappedInput.map { String($0) }[component.wrappedID]
            } else {
                component.value = "_"
            }
        }
    }
    
    func setNewAlphabetValue(_ text: String, for tape: Tape, viewContext: NSManagedObjectContext) {
        var text = text
        // Return if nothin changed
        if tape.wrappedAlphabet == text {
            return
        }
        // Poping last element if possible.
        guard let lastCharacter = text.popLast() else {
            // If not possible -> text is empty.
            updateAlphabet(text, for: tape, viewContext: viewContext)
            removeInputCharactersWhichAreNotInAlphabet(for: tape)
            if let algorithm = tape.algorithm {
                algorithm.editDate = Date.now
            }
            do {
                try viewContext.save()
                print("Alphabet (\(text)) saved successfully.")
            } catch {
                print("Failed saving new alphabet.")
                print(error.localizedDescription)
            }
            return
        }
        
        // If last character is a "space". Remove it.
        if lastCharacter == " " || (lastCharacter == "_" && !text.isEmpty) {
            return
        }  else if !text.contains(lastCharacter) {  // Checking new character already exist
            // if it isn't - add it
            text.append(String(lastCharacter))
            updateAlphabet(text, for: tape, viewContext: viewContext)
            removeInputCharactersWhichAreNotInAlphabet(for: tape)
        }
        
        if let algorithm = tape.algorithm {
            algorithm.editDate = Date.now
        }
        do {
            try viewContext.save()
            print("Alphabet (\(text)) saved successfully.")
        } catch {
            print("Failed saving new alphabet.")
            print(error.localizedDescription)
        }
    }
    
    func setNewInputValue(_ text: String, for tape: Tape, viewContext: NSManagedObjectContext) {
        var text = text
        
        // Return if nothin changed
        if tape.wrappedInput == text {
            return
        }
        
        // Poping last element if possible.
        guard let lastCharacter = text.popLast() else {
            // If not possible -> text is empty.
            updateInput(text, for: tape)
            if let algorithm = tape.algorithm {
                algorithm.editDate = Date.now
            }
            do {
                try viewContext.save()
                print("Input (\(text)) saved successfully.")
            } catch {
                print("Failed saving new input.")
                print(error.localizedDescription)
            }
            return
        }
        
        // if there is such character in alphabet - save it
        // otherwise delete it
        if tape.wrappedAlphabet.contains(lastCharacter) || lastCharacter == "_" {
            text.append(lastCharacter)
        }
        updateInput(text, for: tape)
        if let algorithm = tape.algorithm {
            algorithm.editDate = Date.now
        }
        do {
            try viewContext.save()
            print("Input (\(text)) saved successfully.")
        } catch {
            print("Failed saving new input.")
            print(error.localizedDescription)
        }
    }
}
