//
//  Tape.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 12.12.2023.
//

import Foundation

struct Tape: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let input: String
    let workingInput: String
    let headIndex: Int
    let workingHeadIndex: Int

    var trimmedInput: String {
        input.trim("_")
    }

    var isChanged: Bool {
        let sameInput = self.input == self.workingInput
        let sameHeadIndex = self.headIndex == self.workingHeadIndex
        return !(sameInput && sameHeadIndex)
    }
}

extension Tape {
    init(entity: CDTape) {
        id = entity.id.withDefaultValue("NAN")
        name = entity.name.withDefaultValue("NAN")
        input = entity.input.withDefaultValue("")
        workingInput = entity.workingInput.withDefaultValue("")
        headIndex = Int(entity.headIndex)
        workingHeadIndex = Int(entity.workingHeadIndex)
    }

    init(name: String, input: String = "", headIndex: Int? = nil, includePadding: Bool = true) {
        self.id = UUID().uuidString
        self.name = name
        self.input = includePadding ? input.includePadding() : input
        self.workingInput = self.input
        self.headIndex = headIndex ?? (includePadding ? 200 : 0)
        self.workingHeadIndex = self.headIndex
    }
}

extension Tape {
    func copy(
        id: String? = nil,
        name: String? = nil,
        input: String? = nil,
        workingInput: String? = nil,
        headIndex: Int? = nil,
        workingHeadIndex: Int? = nil,
        includePadding: Bool = true
    ) -> Tape {
        let finalInput: String
        if let input {
            finalInput = includePadding ? input.includePadding() : input
        } else {
            finalInput = self.input
        }

        let finalWorkingInput: String
        if let workingInput {
            finalWorkingInput = includePadding ? workingInput.includePadding() : workingInput
        } else {
            finalWorkingInput = self.workingInput
        }
        return Tape(
            id: id ?? self.id,
            name: name ?? self.name,
            input: finalInput,
            workingInput: finalWorkingInput,
            headIndex: headIndex ?? self.headIndex,
            workingHeadIndex: workingHeadIndex ?? self.workingHeadIndex
        )
    }
}

extension Tape {
    static var sample: Tape {
        Tape(
            name: "Test tape",
            input: "abcdefghijklmnopqrstuvwxyz",
            headIndex: 200
        )
    }

    static var samples: [Tape] {
        [
            Tape(
                name: "Tape 1",
                input: "abcd",
                headIndex: 200
            ),
            Tape(
                name: "Tape 2",
                input: "bbbb",
                headIndex: 200
            ),
            Tape(
                name: "Tape 3",
                input: "cccc",
                headIndex: 200
            )
        ]
    }
}
