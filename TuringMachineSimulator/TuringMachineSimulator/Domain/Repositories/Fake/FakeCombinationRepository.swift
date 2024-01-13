//
//  FakeCombinationRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

final class FakeCombinationRepository: CombinationRepository {

    private var combinations: [Combination]

    init(combinations: [Combination] = [Combination.sample]) {
        self.combinations = combinations
    }

    func getCombinations(optionId: String) async throws -> [Combination] {
        combinations
    }

    func update(combination: Combination) throws {
        if let index = combinations.firstIndex(where: { $0.id == combination.id }) {
            combinations[index] = combination
        } else {
            throw CDError.errorWithMessage("Combination wasnt found.")
        }
    }

    func delete(combination: Combination) throws {
        combinations.removeAll { $0.id == combination.id }
    }

    func save(combination: Combination, option: Option) throws {
        if !self.combinations.contains(where: { $0.id == combination.id }) {
            self.combinations.append(combination)
        }
    }
}
