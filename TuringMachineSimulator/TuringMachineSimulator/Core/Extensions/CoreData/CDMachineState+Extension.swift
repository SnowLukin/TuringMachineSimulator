//
//  CDMachineState.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

extension CDMachineState {
    var unwrappedOptions: [CDOption] {
        guard let options else { return [] }
        return options.compactMap { $0 as? CDOption }
    }
}
