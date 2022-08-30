//
//  CombinationSettingView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct CombinationSettingView: View {
    
    @ObservedObject var combination: Combination
    let tape: Tape
    
    var body: some View {
        Form {
            characterSection()
            directionSection()
        }
        .navigationTitle("Tape \(tape.id) | Character: \(combination.wrappedCharacter)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let state = algorithm.wrappedStates[0]
        let option = state.wrappedOptions[0]
        let combination = option.wrappedCombinations[0]
        let tape = algorithm.wrappedTapes[0]
        NavigationView {
            CombinationSettingView(combination: combination, tape: tape)
        }
    }
}

extension CombinationSettingView {
    @ViewBuilder
    private func characterSection() -> some View {
        Section(header: Text("Change to following character")) {
            NavigationLink {
                ChooseCharView(combination: combination, tape: tape)
            } label: {
                HStack {
                    Text("Alphabet")
                    Spacer()
                    Text(combination.toCharacter ?? "NAN")
                }
            }
        }
    }
    
    @ViewBuilder
    private func directionSection() -> some View {
        Section(header: Text("Move tape's head to following direction")) {
            NavigationLink {
                ChooseDirectionView(combination: combination)
            } label: {
                HStack {
                    Text("Direction")
                    Spacer()
                    Image(systemName: combination.directionImage)
                }
            }
        }
    }
}
