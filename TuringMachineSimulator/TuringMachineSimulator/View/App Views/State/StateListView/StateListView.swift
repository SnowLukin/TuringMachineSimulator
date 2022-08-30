//
//  StateListView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct StateListView: View {
    
    @ObservedObject var algorithm: Algorithm
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = StateListViewModel()
    
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(
                searchText.isEmpty
                ? algorithm.wrappedStates
                : algorithm.wrappedStates.filter( { String($0.wrappedID).contains(searchText) } )
            ) { state in
                NavigationLink {
                    CombinationListView(state: state)
                } label: {
                    Text("# \(state.wrappedID)")
                        .font(.headline)
                }.deleteDisabled(algorithm.wrappedStates.count <= 1)
            }
            .onDelete(perform: deleteStates)
        }
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addStateButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationTitle("States")
    }
}

struct StateListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        NavigationView {
            StateListView(algorithm: algorithm)
                .environment(\.managedObjectContext, context)
        }.navigationViewStyle(.stack)
    }
}

extension StateListView {
    @ViewBuilder
    private func addStateButton() -> some View {
        Button {
            withAnimation {
                viewModel.addState(to: algorithm, viewContext: viewContext)
            }
        } label: {
            Text("Add")
        }
    }
    
    private func deleteStates(offsets: IndexSet) {
        withAnimation {
            let statesForDeletion = offsets.map { algorithm.wrappedStates[$0] }
            for state in statesForDeletion {
                algorithm.removeFromStates(state)
                viewContext.delete(state)
            }
            
            do {
                try viewContext.save()
                print("States successfully deleted and saved.")
            } catch {
                print("Failed saving states after deletion")
                let nsError = error as NSError
                print("\(nsError), \(nsError.userInfo)")
            }
        }
    }
}
