//
//  ActiveStateListScreen.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 27.12.2023.
//

import SwiftUI

struct ActiveStateListScreen: View {

    @StateObject var viewModel: ActiveStateListViewModel

    init(algorithm: Algorithm) {
        let viewModel = Resolver.shared.resolve(ActiveStateListViewModel.self, argument: algorithm)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MachineStateSelectableListView(
            states: viewModel.algorithm.states,
            selectedStateId: viewModel.algorithm.activeStateId
        ) { state in
            viewModel.selectActiveState(state)
        }
        .navigationTitle("Active State")
    }
}
