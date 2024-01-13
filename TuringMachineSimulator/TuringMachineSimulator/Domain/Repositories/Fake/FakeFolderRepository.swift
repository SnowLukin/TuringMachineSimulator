//
//  FakeFolderRepository.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import Combine

final class FakeFolderRepository: FolderRepository {

    private var folders: [Folder]

    init(folders: [Folder] = [Folder.sample]) {
        self.folders = folders
    }

    func getFolders() async throws -> [Folder] {
        folders
    }

    func update(folder: Folder) throws {
        if let index = folders.firstIndex(where: { $0.id == folder.id }) {
            folders[index] = folder
        } else {
            throw CDError.errorWithMessage("Folder not found")
        }
    }

    func delete(folder: Folder) throws {
        folders.removeAll { $0.id == folder.id }
    }

    func save(_ folder: Folder) throws {
        if !self.folders.contains(where: { $0.id == folder.id }) {
            self.folders.append(folder)
        }
    }
}
