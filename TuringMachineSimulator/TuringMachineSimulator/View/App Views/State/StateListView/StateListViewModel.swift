//
//  StateListViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 26.08.2022.
//

import SwiftUI
import CoreData

class StateListViewModel: ObservableObject {
    func addState(to algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        if algorithm.wrappedStates.isEmpty {
            let state = StateQ(context: viewContext)
            state.id = 0
            state.isForReset = true
            state.isStarting = true
            
            algorithm.addToStates(state)
            
            let combinations = getPossibleCombinations(for: state)
            addOptions(to: state, combinations: combinations, viewContext: viewContext)
            
            algorithm.editDate = Date.now
            
            do {
                try viewContext.save()
                print("New state saved successfully.")
            } catch {
                print("Failed saving new state.")
                print(error.localizedDescription)
            }
            
            return
        }
        
        let state = StateQ(context: viewContext)
        
        // Getting the name
        let nameIDArray = algorithm.wrappedStates.map { $0.id }
        guard let max = nameIDArray.max() else {
            print("Error finding max")
            return
        }
        let fullArray = Array(0...max)
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            state.id = Int64(firstElement)
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithm.wrappedStates.last else {
                print("Error finding end element")
                return
            }
            state.id = Int64(endElement.id + 1)
        }
        algorithm.addToStates(state)
        
        let combinations = getPossibleCombinations(for: state)
        addOptions(to: state, combinations: combinations, viewContext: viewContext)
        
        algorithm.editDate = Date.now
        
        do {
            try viewContext.save()
            print("New state saved successfully.")
        } catch {
            print("Failed saving new state.")
            print(error.localizedDescription)
        }
    }
    
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
}
