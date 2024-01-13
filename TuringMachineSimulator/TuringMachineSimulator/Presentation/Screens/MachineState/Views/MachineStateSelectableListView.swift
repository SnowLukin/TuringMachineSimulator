//
//  MachineStateSelectableListView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import SwiftUI

struct MachineStateSelectableListView: View {

    let states: [MachineState]
    let selectedStateId: String?
    let onTapAction: (MachineState) -> Void

    var body: some View {
        List {
            ForEach(states) { state in
                Text(state.name)
                    .foregroundColor(.primary)
                    .selectable(isStateSelected(state))
                    .onTapGesture {
                        withAnimation {
                            onTapAction(state)
                        }
                    }
            }
        }
    }

    private func isStateSelected(_ state: MachineState) -> Bool {
        guard let selectedStateId else { return false }
        return selectedStateId == state.id
    }
}

#Preview {
    let id = UUID().uuidString
    let states = [
        MachineState.sample(withId: id),
        MachineState.sample(withId: "12")
    ]
    return MachineStateSelectableListView(states: states, selectedStateId: id) { _ in }
}
