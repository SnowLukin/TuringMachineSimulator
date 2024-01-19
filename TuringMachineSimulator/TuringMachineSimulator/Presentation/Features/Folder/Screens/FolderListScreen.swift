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
    @State private var showNewFolderAlert = false

    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 100), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                ForEach(viewModel.filteredFolders) { folder in
                    folderCell(folder)
                }
                newFolderButton
            }
            .animation(.default, value: viewModel.filteredFolders)
            .padding()
        }
        .searchable(text: $viewModel.searchText)
        .overlay {
            if viewModel.folders.isEmpty {
                Text("No Folders Yet")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
        }
        .alert("New Folder", isPresented: $showNewFolderAlert) {
            TextFieldAlert(placeholder: "Folder name", action: viewModel.createFolder)
        }
        .onAppear {
            viewModel.fetchFolders()
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

    @ViewBuilder var newFolderButton: some View {
        Button {
            showNewFolderAlert.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round,
                            dash: [5],
                            dashPhase: 5
                        )
                    )
                VStack(spacing: 5) {
                    Image(systemName: "folder")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                        .padding(.top)
                    Text("New folder")
                        .font(.subheadline)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    Image(systemName: "plus")
                        .bold()
                        .padding(.bottom, 10)
                }
            }.foregroundStyle(.blue)
        }
    }
}

#Preview {
    RootView()
}
