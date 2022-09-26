//
//  ChooseCharView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI
import CoreData

class ChooseCharViewModel: ObservableObject {
    func updateToChar(_ combination: Combination, to char: String, viewContext: NSManagedObjectContext) {
        combination.toCharacter = char
        if let algorithm = combination.option?.state?.algorithm {
            algorithm.editDate = Date.now
        }
        do {
            try viewContext.save()
            print("ToChar saved successfully.")
        } catch {
            print("Failed saving new ToChar.")
            print(error.localizedDescription)
        }
    }
}

struct ChooseCharView: View {
    
    @ObservedObject var combination: Combination
    let tape: Tape
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = ChooseCharViewModel()
    
    var body: some View {
        Form {
            ForEach(tape.wrappedAlphabet.map { String($0) }, id: \.self) { alphabetElement in
                Button {
                    viewModel.updateToChar(combination, to: alphabetElement, viewContext: viewContext)
                } label : {
                    HStack {
                        Text(alphabetElement)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if combination.toCharacter == alphabetElement {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                                .transition(
                                    AnyTransition.opacity.animation(
                                        .easeInOut(duration: 0.2)
                                    )
                                )
                        }
                    }
                }.buttonStyle(
                    NoTapColorButtonStyle(colorScheme: colorScheme)
                )
            }
        }
        .navigationTitle("Choose character")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseCharView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let state = algorithm.wrappedStates[0]
        let option = state.wrappedOptions[0]
        let combination = option.wrappedCombinations[0]
        let tape = algorithm.wrappedTapes[0]
        NavigationView {
            ChooseCharView(combination: combination, tape: tape)
                .environment(\.managedObjectContext, context)
        }
    }
}
