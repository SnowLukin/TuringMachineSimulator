//
//  FolderListScreen.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import SwiftUI

struct FolderListScreen: View {

    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = Resolver.shared.resolve(FolderListScreenViewModel.self)

    @State private var showRenameFolderAlert = false

    var body: some View {
        List {
            ForEach(viewModel.filteredFolders) { folder in
                folderCell(folder)
            }.onDelete { indexSet in
                withAnimation {
                    indexSet
                        .map { viewModel.filteredFolders[$0] }
                        .forEach { viewModel.deleteFolder(folder: $0) }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .overlay(alignment: .bottom) {
            NewFolderButton(action: viewModel.createFolder)
        }
        .overlay {
            if viewModel.folders.isEmpty {
                Text("No Folders Yet")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
        }
        .onAppear {
            viewModel.fetchFolders()
        }
        .toolbar {
            EditButton()
        }
        .navigationTitle("Folders")
    }
}

extension FolderListScreen {
    @ViewBuilder func folderCell(_ folder: Folder) -> some View {
        FolderCellView(folder: folder) {
            coordinator.push(.folder(folder))
        }
        .contextMenu {
            Button {
                showRenameFolderAlert.toggle()
            } label: {
                Label("Rename", systemImage: "pencil")
            }

            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteFolder(folder: folder)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Rename Folder", isPresented: $showRenameFolderAlert) {
            TextFieldAlert(placeholder: folder.name) { newName in
                let updatedFolder = folder.copy(name: newName)
                withAnimation {
                    viewModel.updateFolder(folder: updatedFolder)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
