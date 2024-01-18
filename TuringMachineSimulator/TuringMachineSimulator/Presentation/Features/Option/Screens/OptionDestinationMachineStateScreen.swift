//
//  OptionDestinationMachineStateScreen.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 24.12.2023.
//

import SwiftUI

struct OptionDestinationMachineStateScreen: View {

    @StateObject var viewModel: OptionDestinationMachineStateViewModel

    init(option: Option, algorithm: Algorithm) {
        let viewModel = Resolver.shared.resolve(
            OptionDestinationMachineStateViewModel.self,
            arg1: option, arg2: algorithm
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        MachineStateSelectableListView(
            states: viewModel.states,
            selectedStateId: viewModel.destinationStateId
        ) { selectedState in
            viewModel.updateDestinationState(stateId: selectedState.id)
        }
        .onAppear {
            viewModel.fetchStates()
        }
    }
}
