//
//  Combination.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

struct Combination: Identifiable, Codable, Hashable {
    let id: String
    let fromChar: String
    let toChar: String
    let direction: Direction
}

extension Combination {
    init(entity: CDCombination) {
        id = entity.id.withDefaultValue("NAN")
        fromChar = entity.fromChar.withDefaultValue("")
        toChar = entity.toChar.withDefaultValue("")
        direction = Direction.make(from: Int(entity.directionIndex))
    }

    init(fromChar: String) {
        self.id = UUID().uuidString
        self.fromChar = fromChar
        self.toChar = fromChar
        self.direction = .stay
    }

    func copy(
        id: String? = nil,
        fromChar: String? = nil,
        toChar: String? = nil,
        direction: Direction? = nil
    ) -> Combination {
        Combination(
            id: id ?? self.id,
            fromChar: fromChar ?? self.fromChar,
            toChar: toChar ?? self.toChar,
            direction: direction ?? self.direction
        )
    }
}

extension Combination {
    static var sample: Combination {
        Combination(
            id: UUID().uuidString,
            fromChar: "a",
            toChar: "b",
            direction: .stay
        )
    }

    static var samples: [Combination] {
        [
            Combination(
                id: UUID().uuidString,
                fromChar: "a",
                toChar: "b",
                direction: .left
            ),
            Combination(
                id: UUID().uuidString,
                fromChar: "a",
                toChar: "b",
                direction: .stay
            ),
            Combination(
                id: UUID().uuidString,
                fromChar: "a",
                toChar: "b",
                direction: .right
            )
        ]
    }
}
