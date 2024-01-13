//
//  MachineState.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

struct MachineState: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let options: [Option]
}

extension MachineState {
    init(entity: CDMachineState) {
        id = entity.id.withDefaultValue("NAN")
        name = entity.name.withDefaultValue("NAN")
        options = entity.unwrappedOptions.map { Option(entity: $0) }
    }
}

extension MachineState {
    static func sample(withId id: String = UUID().uuidString) -> MachineState {
        MachineState(id: id, name: "Sample State", options: [Option.sample(machineStateId: id)])
    }
}
