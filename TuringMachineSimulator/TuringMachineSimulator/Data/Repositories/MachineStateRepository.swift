//
//  MachineStateRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

protocol MachineStateRepository {
    func getStates(algorithmId: String) async throws -> [MachineState]
    func getStateBy(id: String) async throws -> MachineState
    func update(state: MachineState) throws
    func delete(state: MachineState) throws
    func save(state: MachineState, algorithm: Algorithm) throws
}
