//
//  CombinationView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct CombinationView: View {
    
    @ObservedObject var option: Option
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    CombinationStateView(option: option)
                } label: {
                    Text("Navigate to:")
                        .foregroundColor(.primary)
                    Spacer()
                    Text("State \(option.toState?.wrappedID ?? 0)")
                        .foregroundColor(.gray)
                }
            }
            Section(header: Text("Elements rewriting")) {
                combinationElements()
            }
        }
        .navigationTitle(
            "Combination: \(option.wrappedCombinations.map { $0.wrappedCharacter }.joined(separator: ""))"
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let state = algorithm.wrappedStates[0]
        let option = state.wrappedOptions[0]
        NavigationView {
            CombinationView(option: option)
                .environment(\.managedObjectContext, context)
        }
    }
}

extension CombinationView {
    @ViewBuilder
    private func combinationElements() -> some View {
        ForEach(option.wrappedCombinations) { combination in
            NavigationLink {
                CombinationSettingView(
                    combination: combination,
                    tape: combination.option!.state!.algorithm!.wrappedTapes[Int(combination.id)]
                )
            } label: {
                ElementsRewritingView(combination: combination)
            }
        }
    }
}

struct ElementsRewritingView: View {
    
    @ObservedObject var combination: Combination
    
    var body: some View {
        HStack {
            Text(combination.wrappedCharacter)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Image(systemName: combination.directionImage)
                .font(.title3.bold())
                .foregroundColor(.primary)
            
            Text(combination.toCharacter ?? "NAN")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                
            Divider()
            Text("Tape \(combination.option?.state?.algorithm?.wrappedTapes[Int(combination.id)].id ?? 0)")
                .foregroundColor(Color.gray)
        }
    }
}
