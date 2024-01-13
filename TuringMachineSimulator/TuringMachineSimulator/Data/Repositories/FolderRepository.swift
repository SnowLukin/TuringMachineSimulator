//
//  FolderRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation

protocol FolderRepository {
    func getFolders() async throws -> [Folder]
    func update(folder: Folder) throws
    func delete(folder: Folder) throws
    func save(_ folder: Folder) throws
}
