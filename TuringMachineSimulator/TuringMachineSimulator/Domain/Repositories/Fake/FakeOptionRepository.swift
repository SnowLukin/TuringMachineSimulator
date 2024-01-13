//
//  FakeOptionRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

final class FakeOptionRepository: OptionRepository {

    private var options: [Option]

    init(options: [Option] = [Option.sample()]) {
        self.options = options
    }

    func getOptions(stateId: String) async throws -> [Option] {
        options
    }

    func getOptionById(_ id: String) async throws -> Option {
        options.first ?? Option.sample()
    }

    func update(option: Option) throws {
        if let index = options.firstIndex(where: { $0.id == option.id }) {
            options[index] = option
        } else {
            throw CDError.errorWithMessage("Option not found")
        }
    }

    func delete(option: Option) throws {
        options.removeAll { $0.id == option.id }
    }

    func save(option: Option, state: MachineState) throws {
        if !self.options.contains(where: { $0.id == option.id }) {
            self.options.append(option)
        }
    }
}
