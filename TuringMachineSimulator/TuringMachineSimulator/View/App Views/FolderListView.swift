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
    
    @State private var showNameTakenMessage = false
    @State private var searchFolder = ""
    
    var body: some View {
        ZStack {
            List {
                ForEach(
                    searchFolder.isEmpty
                    ? folders.map {$0}
                    : folders.filter { $0.wrappedName.contains(searchFolder) }
                ) { folder in
                    folderCell(folder)
                        .deleteDisabled(folder.wrappedName == "Algorithms")
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
        .alert("Name is taken", isPresented: $showNameTakenMessage) {
            Button("OK", role: .cancel) {}
        }
        .overlay(alignment: .bottom) {
            addFolderButton()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
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
                    .foregroundColor(.orange)
                    .font(.title2)
                Text(folder.wrappedName).lineLimit(1)
                Spacer()
                Text("\(folder.wrappedAlgorithms.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .contextMenu {
            if folder.wrappedName != "Algorithms" {
                Button {
                    alertTextField(title: "Rename Folder", message: "", hintText: "New name", primaryTitle: "Save", secondaryTitle: "Cancel") { newName in
                        if newName.trimmingCharacters(in: .whitespaces) != "" && !folders.contains(where: { $0.wrappedName == newName }) {
                            folder.name = newName
                            do {
                                try viewContext.save()
                                print("Folder(s) name successfully changed.")
                            } catch {
                                print("Failed changing name.")
                                let nsError = error as NSError
                                print("\(nsError), \(nsError.userInfo)")
                            }
                        } else {
                            withAnimation {
                                showNameTakenMessage.toggle()
                            }
                        }
                    } secondaryAction: { }
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    withAnimation {
                        viewContext.delete(folder)
                        do {
                            try viewContext.save()
                            print("Folder(s) successfully deleted.")
                        } catch {
                            print("Failed deleting folder(s).")
                            let nsError = error as NSError
                            print("\(nsError), \(nsError.userInfo)")
                        }
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
    
    @ViewBuilder
    private func addFolderButton() -> some View {
        HStack {
            Button {
                alertTextField(
                    title: "New Folder",
                    message: "Enter a name for this folder.",
                    hintText: "Name",
                    primaryTitle: "Save", secondaryTitle: "Cancel") { newFolderName in
                        if newFolderName.trimmingCharacters(in: .whitespaces) != "" && !folders.contains(where: { $0.wrappedName == newFolderName }) {
                            saveFolderAction(name: newFolderName)
                        } else {
                            withAnimation {
                                showNameTakenMessage.toggle()
                            }
                        }
                } secondaryAction: {}
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
    
    private func saveFolderAction(name: String) {
        var trimmedFolderName = name.trimmingCharacters(in: .whitespaces)
        if trimmedFolderName == "" {
            trimmedFolderName = "New Folder"
        }
        if folders.map({ $0.wrappedName }).contains(trimmedFolderName) {
            showNameTakenMessage = true
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
