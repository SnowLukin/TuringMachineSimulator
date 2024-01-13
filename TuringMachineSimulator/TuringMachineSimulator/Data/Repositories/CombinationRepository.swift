//
//  CombinationRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

protocol CombinationRepository {
    func getCombinations(optionId: String) async throws -> [Combination]
    func update(combination: Combination) throws
    func delete(combination: Combination) throws
    func save(combination: Combination, option: Option) throws
}
