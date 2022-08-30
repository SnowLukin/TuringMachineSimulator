//
//  StartStateListView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI
import CoreData

class StartStateListViewModel: ObservableObject {
    func changeStartState(to state: StateQ, viewContext: NSManagedObjectContext) {
        guard let algorithm = state.algorithm else {
            print("Failed to get algorithm from state.")
            return
        }
        
        guard let currentStartingState = algorithm.wrappedStates.first(where: { $0.isStarting } ) else {
            print("Failed to find current starting state")
            return
        }
        
        currentStartingState.isStarting.toggle()
        currentStartingState.isForReset.toggle()
        
        state.isStarting.toggle()
        state.isForReset.toggle()
        
        algorithm.editDate = Date.now
        
        do {
            try viewContext.save()
            print("Start state was changed successfully.")
        } catch {
            print("Failed changing start state.")
            print(error.localizedDescription)
        }
    }
}

struct StartStateListView: View {
    
    @ObservedObject var algorithm: Algorithm
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = StartStateListViewModel()
    
    var body: some View {
        List {
            ForEach(algorithm.wrappedStates) { state in
                Button {
                    viewModel.changeStartState(to: state, viewContext: viewContext)
                } label: {
                    HStack {
                        Text("State \(state.id)")
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if state.isStarting {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .transition(
                                    AnyTransition.opacity.animation(.easeInOut(duration: 0.2))
                                )
                        }
                    }
                }
                .buttonStyle(
                    NoTapColorButtonStyle(colorScheme: colorScheme)
                )
            }
        }
        .navigationTitle("Current state")
    }
}

struct StartStateListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        StartStateListView(algorithm: algorithm)
            .environment(\.managedObjectContext, context)
    }
}
