//
//  CombinationStateView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI
import CoreData

class CombinationStateViewModel: ObservableObject {
    func updateToState(_ option: Option, to state: StateQ, viewContext: NSManagedObjectContext) {
        state.addToFromOptions(option)
        option.toState = state
        
        do {
            try viewContext.save()
            print("ToState saved successfully.")
        } catch {
            print("Failed saving new ToState.")
            print(error.localizedDescription)
        }
    }
}

struct CombinationStateView: View {
    
    @ObservedObject var option: Option
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = CombinationStateViewModel()
    
    var body: some View {
        List(option.state?.algorithm?.wrappedStates ?? []) { currentState in
            Button {
                viewModel.updateToState(option, to: currentState, viewContext: viewContext)
            } label: {
                HStack {
                    Text("State \(currentState.id)")
                        .foregroundColor(.primary)
                    Spacer()
                    
                    if option.toState == currentState {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.blue)
                            .transition(
                                AnyTransition.opacity.animation(
                                    .easeInOut(duration: 0.2)
                                )
                            )
                    }
                }
            }
            .buttonStyle(
                NoTapColorButtonStyle(colorScheme: colorScheme)
            )
        }
    }
}

struct CombinationStateView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let state = algorithm.wrappedStates[0]
        let option = state.wrappedOptions[0]
        CombinationStateView(option: option)
            .environment(\.managedObjectContext, context)
    }
}
