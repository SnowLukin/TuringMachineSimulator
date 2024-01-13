//
//  FolderListScreenViewModel.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import SwiftUI

final class FolderListScreenViewModel: ObservableObject {

    @Published var folders: [Folder] = []
    @Published var searchText = ""
    private let folderRepository: FolderRepository

    var filteredFolders: [Folder] {
        searchText.isEmpty
        ? folders
        : folders.filter { $0.name.contains(searchText) }
    }

    init(folderRepository: FolderRepository) {
        self.folderRepository = folderRepository
    }

    func fetchFolders() {
        Task { @MainActor in
            do {
                folders = try await folderRepository.getFolders()
            } catch {
                AppLogger.error(error.localizedDescription)
            }
        }
    }

    func createFolder(_ name: String) {
        do {
            let name = name.isEmpty ? "New Folder" : name
            let folder = Folder(id: UUID().uuidString, name: name, algorithms: [])
            try folderRepository.save(folder)
            fetchFolders()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func deleteFolder(folder: Folder) {
        do {
            try folderRepository.update(folder: folder)
            fetchFolders()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func updateFolder(folder: Folder) {
        do {
            try folderRepository.update(folder: folder)
            fetchFolders()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
