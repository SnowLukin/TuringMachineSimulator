//
//  CDAlgorithm+Extension.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 12.12.2023.
//

import Foundation
import CoreData

extension CDAlgorithm {
    var unwrappedTapes: [CDTape] {
        guard let tapes else { return [] }
        return tapes.compactMap { $0 as? CDTape }
    }

    var unwrappedStates: [CDMachineState] {
        guard let states else { return [] }
        return states.compactMap { $0 as? CDMachineState }
    }
}
