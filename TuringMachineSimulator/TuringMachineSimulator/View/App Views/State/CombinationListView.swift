//
//  CombinationListView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct CombinationListView: View {
    
    @ObservedObject var state: StateQ
    
    var body: some View {
        List(state.wrappedOptions) { option in
            NavigationLink {
                CombinationView(option: option)
            } label: {
                Text("\(option.wrappedCombinations.map { $0.wrappedCharacter }.joined(separator: ""))")
            }
        }
        .navigationTitle(state.wrappedOptions.isEmpty ? "Empty" : "State \(state.wrappedID)'s combinations")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let state = algorithm.wrappedStates[0]
        NavigationView {
            CombinationListView(state: state)
        }
    }
}
