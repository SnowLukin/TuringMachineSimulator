//
//  AlgorithmListView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct AlgorithmListView: View {
    
    @ObservedObject var folder: Folder
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var viewModel = AlgorithmListViewModel()
    @StateObject private var importViewModel = ImportAlgorithmViewModel()
    @State private var showImport = false
    @State private var searchedAlgorithm = ""
    
    var body: some View {
        ZStack {
            List {
                ForEach(
                    searchedAlgorithm.isEmpty
                    ? folder.wrappedAlgorithms
                    : folder.wrappedAlgorithms.filter({ $0.wrappedName.contains(searchedAlgorithm) })
                ) { algorithm in
                    AlgorithmListCellView(algorithm: algorithm)
                }
                .onDelete(perform: deleteAlgorithm)
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchedAlgorithm)
            
            if folder.wrappedAlgorithms.isEmpty {
                noAlgorithmViewMessage()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showImport.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .overlay(alignment: .bottom) {
            algorithmCreationView()
        }
        
        .fileImporter(isPresented: $showImport, allowedContentTypes: [.mtm], allowsMultipleSelection: false) { result in
            withAnimation {
                importViewModel.handleImport(result, folder: folder, viewContext: viewContext)
            }
        }
        .navigationTitle(folder.wrappedName)
    }
}

struct AlgorithmListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        NavigationView {
            AlgorithmListView(folder: folder)
                .environment(\.managedObjectContext, context)
        }
        .preferredColorScheme(.dark)
    }
}

extension AlgorithmListView {
    
    @ViewBuilder
    private func noAlgorithmViewMessage() -> some View {
        VStack {
            Text("No algorithms.")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Text("You can add algorithms by clicking \"document\" icon below.")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }.padding(.horizontal)
    }
    @ViewBuilder
    private func algorithmCreationView() -> some View {
        HStack {
            Spacer()
            Button {
                alertTextField(
                    title: "New Algorithm",
                    message: "Enter a name for this algorithm.",
                    hintText: "Name",
                    primaryTitle: "Save", secondaryTitle: "Cancel"
                ) { newAlgorithmName in
                    withAnimation {
                        viewModel.createAlgorithm(
                            newAlgorithmName.trimmingCharacters(in: .whitespaces),
                            for: folder, viewContext: viewContext
                        )
                    }
                } secondaryAction: {}
            } label: {
                Image(systemName: "doc.badge.plus")
                    .font(.title2)
            }
        }
        .padding()
        .background(.ultraThickMaterial)
    }
    
    private func deleteAlgorithm(offsets: IndexSet) {
        withAnimation {
            let selectedAlgorithms = offsets.map { folder.wrappedAlgorithms[$0] }
            for algorithm in selectedAlgorithms {
                folder.removeFromAlgorithms(algorithm)
                viewContext.delete(algorithm)
            }
            
            do {
                try viewContext.save()
                print("Algorithm successfully deleted.")
            } catch {
                print("Failed deleting algorithm.")
                let nsError = error as NSError
                print("\(nsError), \(nsError.userInfo)")
            }
        }
    }
}
