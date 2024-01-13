//
//  OptionListView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import SwiftUI

struct OptionListView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: OptionListViewModel
    @State private var showNewOptionAlert = false

    let algorithm: Algorithm

    init(state: MachineState, algorithm: Algorithm) {
        let viewModel = Resolver.shared.resolve(OptionListViewModel.self, argument: state)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.algorithm = algorithm
    }

    var body: some View {
        List {
            ForEach(viewModel.filteredOptions) { option in
                Button(option.joinedCombinations) {
                    coordinator.push(.option(option, algorithm))
                }.foregroundStyle(.primary)
            }.onDelete { indexSet in
                withAnimation {
                    indexSet
                        .map { viewModel.filteredOptions[$0] }
                        .forEach { viewModel.deleteOption($0) }
                }
            }
        }
        .onAppear {
            viewModel.fetchOptions()
        }
        .searchable(text: $viewModel.searchText)
        .toolbar {
            Button("Add") {
                showNewOptionAlert.toggle()
            }
            EditButton()
        }
        .alert("New Combination", isPresented: $showNewOptionAlert) {
            TextFieldAlert(placeholder: "", action: viewModel.createOption)
        } message: {
            Text("Enter new combination")
        }
        .navigationTitle("\(viewModel.state.name)'s combinations")
        .navigationBarTitleDisplayMode(.inline)
    }
}
