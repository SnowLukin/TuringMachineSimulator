//
//  AlgorithmCreationViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI
import CoreData

class AlgorithmListViewModel: ObservableObject {
    
    func getAlgorithmEditedTimeForTextView(_ date: Date) -> String {
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: date)
    }
    
    func createAlgorithm(_ name: String, for folder: Folder, viewContext: NSManagedObjectContext) {
        let algorithm = Algorithm(context: viewContext)
        algorithm.name = name
        let currentDate = Date.now
        algorithm.creationDate = currentDate
        algorithm.editDate = currentDate
        addTape(to: algorithm, viewContext: viewContext)
        addState(to: algorithm, viewContext: viewContext)
        folder.addToAlgorithms(algorithm)
        do {
            try viewContext.save()
            print("Algorithm saved successfully.")
        } catch {
            print("Failed saving new algorithm.")
            print(error.localizedDescription)
        }
    }
    
    private func addTape(to algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        // Tape
        let tape = Tape(context: viewContext)
        tape.id = 0
        tape.headIndex = 0
        tape.alphabet = "_"
        tape.input = ""
        algorithm.addToTapes(tape)
        
        for index in -80..<81 {
            // Components
            let component = TapeComponent(context: viewContext)
            component.id = Int64(index)
            if (0..<tape.wrappedInput.count).contains(index) {
                component.value = tape.wrappedInput.map { String($0) }[index]
            } else {
                component.value = "_"
            }
            tape.addToComponents(component)
        }
    }
    
    private func addState(to algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        // State
        let state = StateQ(context: viewContext)
        state.id = 0
        state.isForReset = true
        state.isStarting = true
        
        // Options
        let option = Option(context: viewContext)
        option.id = 0
        
        // Combinations
        let combination = Combination(context: viewContext)
        combination.id = 0
        combination.direction = 0
        let character = "_"
        combination.character = character
        combination.toCharacter = character
        
        option.addToCombinations(combination)
        
        state.addToOptions(option)
        state.addToFromOptions(option)
        
        algorithm.addToStates(state)
    }
}

