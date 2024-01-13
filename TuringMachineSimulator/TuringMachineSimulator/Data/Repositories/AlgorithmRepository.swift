//
//  AlgorithmRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation

protocol AlgorithmRepository {
    func getAlgorithms(folderId: String) async throws -> [Algorithm]
    func getAlgorithmBy(id: String) async throws -> Algorithm
    func update(algorithm: Algorithm) throws
    func delete(algorithm: Algorithm) throws
    func save(algorithm: Algorithm, folder: Folder) throws
}
