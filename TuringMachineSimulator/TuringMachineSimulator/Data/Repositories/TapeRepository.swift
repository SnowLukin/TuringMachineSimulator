//
//  TapeRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

protocol TapeRepository {
    func getTapes(algorithmId: String) async throws -> [Tape]
    func getTapeById(_ id: String) async throws -> Tape
    func update(tape: Tape) throws
    func delete(tape: Tape) throws
    func save(tape: Tape, algorithm: Algorithm) throws
}
