//
//  FakeMachineStateRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

final class FakeMachineStateRepository: MachineStateRepository {

    private var states: [MachineState]

    init(states: [MachineState] = MachineState.samples()) {
        self.states = states
    }

    func getStates(algorithmId: String) async throws -> [MachineState] {
        states
    }

    func getStateBy(id: String) async throws -> MachineState {
        states.first ?? MachineState.sample()
    }

    func update(state: MachineState) throws {
        if let index = states.firstIndex(where: { $0.id == state.id }) {
            states[index] = state
        } else {
            throw CDError.errorWithMessage("State wasnt found.")
        }
    }

    func delete(state: MachineState) throws {
        states.removeAll { $0.id == state.id }
    }

    func save(state: MachineState, algorithm: Algorithm) throws {
        if !self.states.contains(where: { $0.id == state.id }) {
            self.states.append(state)
        }
    }
}
