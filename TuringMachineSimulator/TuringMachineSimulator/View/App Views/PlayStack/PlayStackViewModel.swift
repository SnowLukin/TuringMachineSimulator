//
//  PlayStackViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 25.08.2022.
//

import SwiftUI
import CoreData

class PlayStackViewModel: ObservableObject {
    
    func reset(algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        updateAllTapesComponents(of: algorithm, viewContext: viewContext)
        for state in algorithm.wrappedStates {
            state.isStarting = state.isForReset
        }
        do {
            try viewContext.save()
            print("Step was made successfully.")
        } catch {
            print("Failed making the step.")
            print(error.localizedDescription)
        }
    }
    func makeStep(algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        var combination: [String] = []
        
        // Gathering the components that are under tapes' head index
        for tape in algorithm.wrappedTapes {
            guard let component = tape.wrappedComponents.first(where: { $0.wrappedID == tape.wrappedHeadIndex }) else {
                print("Error finding component equals to tape head index")
                return
            }
            combination.append(component.wrappedValue)
        }
        
        // Finding starting state
        guard let startState = algorithm.wrappedStates.first(where: { $0.isStarting }) else {
            print("Error getting start state")
            return
        }
        
        // Finding needed option in state
        guard let currentOption = startState.wrappedOptions.first(where: { $0.wrappedCombinations.map { $0.character } == combination }) else {
            print("Error finding current option")
            return
        }
        print("Current option id: \(currentOption.wrappedID)")
        
        for index in 0..<combination.count {
            let currentTape = algorithm.wrappedTapes[index]
            guard let component = currentTape.wrappedComponents.first(where: { $0.id == currentTape.headIndex }) else {
                print("Error finding component")
                return
            }
            component.value = currentOption.wrappedCombinations[index].toCharacter
            
            switch currentOption.wrappedCombinations[index].wrappedDirection {
            case 0:
                break
            case 1:
                if currentTape.wrappedHeadIndex != -80 {
                    currentTape.headIndex -= 1
                }
            default:
                if currentTape.wrappedHeadIndex != 80 {
                    currentTape.headIndex += 1
                }
            }
        }
        
        // Setting new start state
        print(startState.wrappedID)
        startState.isStarting.toggle()
        guard let toState = algorithm.wrappedStates.first(where: { $0 == currentOption.toState }) else {
            print(currentOption.wrappedID)
            print("Error. Couldnt find toState.")
            return
        }
        toState.isStarting.toggle()
        
        do {
            try viewContext.save()
            print("Step was made successfully.")
        } catch {
            print("Failed making the step.")
            print(error.localizedDescription)
        }
    }
    
    private func updateComponents(of tape: Tape, viewContext: NSManagedObjectContext) {
        // Update components values according to input
        for component in tape.wrappedComponents {
            if (0..<tape.wrappedInput.count).contains(component.wrappedID) {
                component.value = tape.wrappedInput.map { String($0) }[component.wrappedID]
            } else {
                component.value = "_"
            }
        }
    }
    
    private func updateAllTapesComponents(of algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        for tape in algorithm.wrappedTapes {
            updateComponents(of: tape, viewContext: viewContext)
            tape.headIndex = 0
        }
        
        algorithm.editDate = Date.now
    }
}
