//
//  ChooseDirectionView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI
import CoreData

class ChooseDirectionViewModel: ObservableObject {
    func updateDirection(_ combination: Combination, to directionID: Int, viewContext: NSManagedObjectContext) {
        combination.direction = Int64(directionID)
        do {
            try viewContext.save()
            print("New direction saved successfully.")
        } catch {
            print("Failed saving new direction.")
            print(error.localizedDescription)
        }
    }
}

struct ChooseDirectionView: View {
    
    @ObservedObject var combination: Combination
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var viewContext
    @StateObject private var viewModel = ChooseDirectionViewModel()
    
    var body: some View {
        Form {
            ForEach(0..<3, id: \.self) { directionID in
                Button {
                    viewModel.updateDirection(combination, to: directionID, viewContext: viewContext)
                } label: {
                    HStack {
                        Image(systemName: directionID == 0 ? "arrow.counterclockwise" : directionID == 1 ? "arrow.left" : "arrow.right")
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if combination.wrappedDirection == directionID {
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
                .buttonStyle(NoTapColorButtonStyle(colorScheme: colorScheme))
            }
        }
        .navigationTitle("Choose direction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseDirectionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let state = algorithm.wrappedStates[0]
        let option = state.wrappedOptions[0]
        let combination = option.wrappedCombinations[0]
        NavigationView {
            ChooseDirectionView(combination: combination)
                .environment(\.managedObjectContext, context)
        }
    }
}
