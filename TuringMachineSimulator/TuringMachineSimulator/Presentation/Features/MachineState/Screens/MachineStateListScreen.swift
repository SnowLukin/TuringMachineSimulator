//
//  MachineStateListScreen.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import SwiftUI

struct MachineStateListScreen: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: MachineStateListViewModel
    @State private var showAddingAlert = false

    init(algorithm: Algorithm) {
        let viewModel = Resolver.shared.resolve(MachineStateListViewModel.self, argument: algorithm)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            ForEach(viewModel.filteredStates) { state in
                Button(state.name) {
                    coordinator.push(.optionList(state, viewModel.algorithm))
                }.foregroundStyle(.primary)
                .deleteDisabled(viewModel.states.count <= 1)
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet
                        .map { viewModel.filteredStates[$0] }
                        .forEach { viewModel.deleteState($0) }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .onAppear {
            viewModel.fetchAlgorithm()
        }
        .alert("New state", isPresented: $showAddingAlert) {
            TextFieldAlert(placeholder: "State \(viewModel.states.count)", action: viewModel.createState)
        }
        .toolbar {
            Button("Add") {
                showAddingAlert.toggle()
            }
            EditButton()
        }
        .navigationTitle("States")
    }
}

#Preview {
    MachineStateListScreen(algorithm: Algorithm.sample)
}
