//
//  SampleData.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import Foundation
import CoreData

struct SampleData {
    
    func prepareData(for context: NSManagedObjectContext) {
        // MARK: - Tape
        let tape = Tape(context: context)
        tape.id = 0
        tape.headIndex = 0
        tape.alphabet = "_abc"
        tape.input = "aabbcc"
        
        for index in -80..<81 {
            // MARK: - Component
            let component = TapeComponent(context: context)
            component.id = Int64(index)
            if (0..<tape.wrappedInput.count).contains(index) {
                component.value = tape.wrappedInput.map { String($0) }[index]
            } else {
                component.value = "_"
            }
            tape.addToComponents(component)
        }
        
        // MARK: - State
        let state = StateQ(context: context)
        state.id = 0
        state.isForReset = true
        state.isStarting = true
        
        // MARK: - Option
        for index in 0..<tape.wrappedAlphabet.count {
            let option = Option(context: context)
            option.id = Int64(index)
            
            // MARK: - Combination
            let combination = Combination(context: context)
            combination.id = 0
            combination.direction = 0
            let character = tape.wrappedAlphabet.map{ String($0) }[index]
            combination.character = character
            combination.toCharacter = character
            
            option.addToCombinations(combination)
            
            state.addToOptions(option)
            state.addToFromOptions(option)
        }
        
        
        // MARK: - Algorithm
        let algorithm = Algorithm(context: context)
        algorithm.name = "Test Algorithm"
        algorithm.pinned = false
        
        algorithm.addToTapes(tape)
        
        algorithm.addToStates(state)
        
        // MARK: - Folder
        let folder = Folder(context: context)
        folder.name = "Algorithms"
        
        folder.addToAlgorithms(algorithm)
        
        // MARK: - Save Context
        do {
            try context.save()
        } catch {
            // handle error for production
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
