//
//  FolderListView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI
import CoreData

class FolderListViewModel: ObservableObject {
    func createFolder(_ name: String, viewContext: NSManagedObjectContext) {
        let folder = Folder(context: viewContext)
        folder.name = name
        
        do {
            try viewContext.save()
            print("Folder saved successfully.")
        } catch {
            print("Failed saving new folder.")
            print(error.localizedDescription)
        }
    }
}

struct FolderListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = FolderListViewModel()
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Folder.name, ascending: true)
        ],
        animation: .default)
    private var folders: FetchedResults<Folder>
    
    @State private var showCreationFolderView = false
    @State private var showNameTakenMessage = false
    
    @State private var newFolderName = ""
    @State private var searchFolder = ""
    
    var body: some View {
        ZStack {
            List {
                ForEach(
                    searchFolder.isEmpty
                    ? folders.map {$0}
                    : folders.filter { $0.wrappedName.contains(searchFolder) }
                ) { folder in
                    folderCell(folder).deleteDisabled(folder.wrappedName == "Algorithms")
                }
                .onDelete(perform: deleteFolders)
            }
            .searchable(text: $searchFolder)
            
            if folders.isEmpty {
                VStack {
                    Text("No folders.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    Text("You can add folders by clicking \"folder\" icon below.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }.padding(.horizontal)
            }
        }
        .textfieldAlert(show: $showCreationFolderView, text: $newFolderName, title: "New Folder", textfieldPlaceholder: "Name", disabledWhenEmpty: true) {
            // Cancel action
        } saveAction: {
            saveFolderAction()
        }
        .alert(show: $showNameTakenMessage, title: "Name taken",
               subTitle: "Please choose differrent name", action: {}
        )
        .overlay(alignment: .bottom) {
            if !showCreationFolderView && !showNameTakenMessage {
                addFolderButton()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .disabled(showCreationFolderView || showNameTakenMessage)
            }
        }
        .navigationTitle("Folders")
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderListView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }.navigationViewStyle(.stack)
    }
}

extension FolderListView {
    @ViewBuilder
    private func folderCell(_ folder: Folder) -> some View {
        NavigationLink {
            AlgorithmListView(folder: folder)
        } label: {
            HStack {
                Image(systemName: "folder")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text(folder.wrappedName).lineLimit(1)
                Spacer()
                Text("\(folder.wrappedAlgorithms.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    @ViewBuilder
    private func addFolderButton() -> some View {
        HStack {
            Button {
                withoutAnimation {
                    showCreationFolderView.toggle()
                }
            } label: {
                Image(systemName: "folder.badge.plus")
                    .font(.title2)
            }
            Spacer()
        }
        .padding()
        .background(
            colorScheme == .dark
            ? Color(uiColor: .systemBackground)
            : Color(uiColor: .secondarySystemBackground)
        )
    }
    
    private func saveFolderAction() {
        var trimmedFolderName = newFolderName.trimmingCharacters(in: .whitespaces)
        if trimmedFolderName == "" {
            trimmedFolderName = "New Folder"
        }
        if folders.map({ $0.wrappedName }).contains(trimmedFolderName) {
            withoutAnimation {
                showNameTakenMessage = true
            }
        } else {
            viewModel.createFolder(trimmedFolderName, viewContext: viewContext)
        }
    }
    
    private func deleteFolders(offsets: IndexSet) {
        withAnimation {
            offsets.map { folders[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                print("Folder(s) successfully deleted.")
            } catch {
                print("Failed deleting folder(s).")
                let nsError = error as NSError
                print("\(nsError), \(nsError.userInfo)")
            }
        }
    }
}
