//
//  ImportAlgorithmViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import SwiftUI
import CoreData

class ImportAlgorithmViewModel: ObservableObject {
    func handleImport(_ result: Result<[URL], Error>, folder: Folder, viewContext: NSManagedObjectContext) {
        do {
            guard let selectedFileURL: URL = try result.get().first else {
                print("Failed getting url")
                return
            }
            if selectedFileURL.startAccessingSecurityScopedResource() {
                guard let data = try? Data(contentsOf: selectedFileURL) else {
                    print("Failed getting data from url: \(selectedFileURL)")
                    return
                }
                guard let algorithm = try? JSONDecoder().decode(AlgorithmShare.self, from: data) else {
                    print("Failed decoding file.")
                    return
                }
                defer {
                    selectedFileURL.stopAccessingSecurityScopedResource()
                }
                importAlgorithm(algorithm, to: folder, viewContext: viewContext)
                print("Algorithm imported successfully.")
            } else {
                print("Error occupied. Failed accessing security scoped resource.")
            }
        } catch {
            print("Error occupied: \(error.localizedDescription)")
        }
    }
    
    private func importAlgorithm(_ sharedAlgorithm: AlgorithmShare, to folder: Folder, viewContext: NSManagedObjectContext) {
        let algorithm = Algorithm(context: viewContext)
        algorithm.name = sharedAlgorithm.name
        algorithm.algDescription = sharedAlgorithm.algorithmDescription
        importTapes(sharedAlgorithm.tapes, to: algorithm, viewContext: viewContext)
        importStates(sharedAlgorithm.states, to: algorithm, viewContext: viewContext)
        folder.addToAlgorithms(algorithm)
        
        do {
            try viewContext.save()
            print("Imported algorithm saved successfully.")
        } catch {
            print("Failed saving imported algorithm.")
            print(error.localizedDescription)
        }
    }
    
    private func importTapes(_ sharedTapes: [TapeShare], to algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        for sharedTape in sharedTapes {
            let tape = Tape(context: viewContext)
            tape.id = sharedTape.id
            tape.headIndex = sharedTape.headIndex
            tape.alphabet = sharedTape.alphabet
            tape.input = sharedTape.input
            
            addComponents(to: tape, viewContext: viewContext)
            
            algorithm.addToTapes(tape)
        }
    }
    
    private func addComponents(to tape: Tape, viewContext: NSManagedObjectContext) {
        for index in -200..<201 {
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
    
    private func importStates(_ sharedStates: [StateQShare], to algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        for sharedState in sharedStates {
            let state = StateQ(context: viewContext)
            state.id = sharedState.id
            state.isForReset = sharedState.isForReset
            state.isStarting = sharedState.isStarting
            
            algorithm.addToStates(state)
        }
        
        // Second loop needed for setting ToState
        
        for sharedState in sharedStates {
            importOptions(
                sharedState.options,
                to: algorithm.wrappedStates.first(where: { $0.id == sharedState.id }) ?? algorithm.wrappedStates[0],
                algorithm: algorithm,
                viewContext: viewContext
            )
        }
        
    }
    
    private func importOptions(_ sharedOptions: [OptionShare], to state: StateQ, algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        for sharedOption in sharedOptions {
            let option = Option(context: viewContext)
            option.id = sharedOption.id
            
            state.addToOptions(option)
            
            if let toState = algorithm.wrappedStates.first(where: { $0.id == sharedOption.toStateID }) {
                toState.addToFromOptions(option)
            } else {
                state.addToFromOptions(option)
            }
            importCombinations(sharedOption.combinations, to: option, viewContext: viewContext)
        }
    }
    
    private func importCombinations(_ sharedCombinations: [CombinationShare], to option: Option, viewContext: NSManagedObjectContext) {
        for sharedCombination in sharedCombinations {
            let combination = Combination(context: viewContext)
            combination.id = sharedCombination.id
            combination.direction = sharedCombination.directionID
            combination.character = sharedCombination.character
            combination.toCharacter = sharedCombination.toCharacter
            
            option.addToCombinations(combination)
        }
    }
}
