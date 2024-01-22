//
//  Option.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

struct Option: Identifiable, Codable, Hashable {
    let id: String
    let toStateId: String
    let combinations: [Combination]
}

extension Option {
    var joinedCombinations: String {
        combinations
            .map { $0.fromChar }
            .joined(separator: "")
    }
}

extension Option {
    init(entity: CDOption) {
        id = entity.id.withDefaultValue("NAN")
        toStateId = entity.toStateId.withDefaultValue("")
        combinations = entity.unwrappedCombinations.map { Combination(entity: $0) }
    }

    func copy(
        id: String? = nil,
        toStateId: String? = nil,
        combinations: [Combination]? = nil
    ) -> Option {
        Option(
            id: id ?? self.id,
            toStateId: toStateId ?? self.toStateId,
            combinations: combinations ?? self.combinations
        )
    }
}

extension Option {
    static func sample(machineStateId: String = "") -> Option {
        Option(id: UUID().uuidString, toStateId: machineStateId, combinations: [Combination.sample])
    }

    static func samples(machineStateId: String = "") -> [Option] {
        [
            Option(id: UUID().uuidString, toStateId: machineStateId, combinations: [
                Combination(id: UUID().uuidString, fromChar: "a", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "b", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "c", toChar: "f", direction: .right)
            ]),
            Option(id: UUID().uuidString, toStateId: machineStateId, combinations: [
                Combination(id: UUID().uuidString, fromChar: "b", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "b", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "c", toChar: "f", direction: .right)
            ]),
            Option(id: UUID().uuidString, toStateId: machineStateId, combinations: [
                Combination(id: UUID().uuidString, fromChar: "c", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "b", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "c", toChar: "f", direction: .right)
            ]),
            Option(id: UUID().uuidString, toStateId: machineStateId, combinations: [
                Combination(id: UUID().uuidString, fromChar: "d", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "b", toChar: "f", direction: .right),
                Combination(id: UUID().uuidString, fromChar: "c", toChar: "f", direction: .right)
            ])
        ]
    }
}
