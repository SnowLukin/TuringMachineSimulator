//
//  CDFolder+Extension.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 12.12.2023.
//

import Foundation
import CoreData

extension CDFolder {
    var unwrappedAlgorithms: [CDAlgorithm] {
        guard let algorithms else { return [] }
        return algorithms.compactMap { $0 as? CDAlgorithm }
    }
}
