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
    @State private var showCreationAlgorithmView = false
    @State private var showImport = false
    @State private var searchedAlgorithm = ""
    @State private var text = ""
    
    var body: some View {
        ZStack {
            List {
                ForEach(
                    searchedAlgorithm.isEmpty
                    ? folder.wrappedAlgorithms
                    : folder.wrappedAlgorithms.filter({ $0.wrappedName.contains(searchedAlgorithm) })
                ) { algorithm in
                    NavigationLink {
                        AlgorithmView(algorithm: algorithm)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(algorithm.wrappedName)
                                .font(.headline)
                                .lineLimit(1)
                            Text(viewModel.getAlgorithmEditedTimeForTextView(algorithm.wrappedEditDate))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
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
        .textfieldAlert(
            show: $showCreationAlgorithmView,
            text: $text,
            title: "New Algorithm",
            textfieldPlaceholder: "Name"
        ) {
            // Cancel action
        } saveAction: {
            viewModel.createAlgorithm(
                text.trimmingCharacters(in: .whitespaces),
                for: folder,
                viewContext: viewContext
            )
        }
        .overlay(alignment: .bottom) {
            if !showCreationAlgorithmView {
                algorithmCreationView()
            }
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
                withoutAnimation {
                    showCreationAlgorithmView.toggle()
                }
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
