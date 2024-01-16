//
//  Algorithm.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 12.12.2023.
//

import Foundation

struct Algorithm: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let algDescription: String
    let createdDate: Date
    let lastEditDate: Date
    let startingStateId: String
    let activeStateId: String
    let tapes: [Tape]
    let states: [MachineState]
}

extension Algorithm {
    init(entity: CDAlgorithm) {
        id = entity.id.withDefaultValue("NAN")
        name = entity.name.withDefaultValue("NAN")
        algDescription = entity.algDescription.withDefaultValue("NAN")
        createdDate = entity.createdDate.withDefaultValue(.now)
        lastEditDate = entity.lastEditDate.withDefaultValue(.now)
        startingStateId = entity.startingStateId.withDefaultValue("")
        activeStateId = entity.activeStateId.withDefaultValue("")
        tapes = entity.unwrappedTapes.map { Tape(entity: $0) }
        states = entity.unwrappedStates.map { MachineState(entity: $0) }
    }

    init(name: String) {
        self.init(
            id: UUID().uuidString,
            name: name,
            algDescription: "",
            createdDate: .now,
            lastEditDate: .now,
            startingStateId: "",
            activeStateId: "",
            tapes: [],
            states: []
        )
    }

    var isChanged: Bool {
        !tapes.filter { $0.isChanged }.isEmpty
    }

    func copy(
        name: String? = nil,
        algDescription: String? = nil,
        createdDate: Date? = nil,
        lastEditDate: Date? = nil,
        startingStateId: String? = nil,
        activeStateId: String? = nil,
        tapes: [Tape]? = nil,
        states: [MachineState]? = nil
    ) -> Algorithm {
        Algorithm(
            id: self.id,
            name: name ?? self.name,
            algDescription: algDescription ?? self.algDescription,
            createdDate: createdDate ?? self.createdDate,
            lastEditDate: lastEditDate ?? self.lastEditDate,
            startingStateId: startingStateId ?? self.startingStateId,
            activeStateId: activeStateId ?? self.activeStateId,
            tapes: tapes ?? self.tapes,
            states: states ?? self.states
        )
    }
}

extension Algorithm {
    static var sample: Algorithm {
        let machineStateId = UUID().uuidString
        return Algorithm(
            id: UUID().uuidString,
            name: "Sample Algorithm",
            algDescription: "Test",
            createdDate: .now,
            lastEditDate: .now,
            startingStateId: machineStateId,
            activeStateId: machineStateId,
            tapes: [Tape.sample],
            states: [MachineState.sample(withId: machineStateId)]
        )
    }
}
