//
//  OptionRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

protocol OptionRepository {
    func getOptions(stateId: String) async throws -> [Option]
    func getOptionById(_ id: String) async throws -> Option
    func update(option: Option) throws
    func delete(option: Option) throws
    func save(option: Option, state: MachineState) throws
}
