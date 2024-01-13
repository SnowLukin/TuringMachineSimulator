//
//  CDOption+Extension.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

extension CDOption {
    var unwrappedCombinations: [CDCombination] {
        guard let combinations else { return [] }
        return combinations.compactMap { $0 as? CDCombination }
    }
}
