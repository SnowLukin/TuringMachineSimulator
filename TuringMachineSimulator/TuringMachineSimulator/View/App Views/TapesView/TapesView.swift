//
//  TapesView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct TapesView: View {
    
    @ObservedObject var algorithm: Algorithm
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TapesViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(algorithm.wrappedTapes) { tape in
                TapeSectionOpeningView(tape: tape)
            }
        }
        .navigationTitle("Tapes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Tape") {
                    withAnimation {
                        viewModel.addTape(algorithm: algorithm, viewContext: viewContext)
                    }
                }.disabled(algorithm.wrappedTapes.count > 10)
            }
        }
    }
}

struct TapesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        NavigationView {
            TapesView(algorithm: algorithm)
                .environment(\.managedObjectContext, context)
        }
    }
}
