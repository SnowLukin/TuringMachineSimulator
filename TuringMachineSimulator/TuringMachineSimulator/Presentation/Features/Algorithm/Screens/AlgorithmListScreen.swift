//
//  AlgorithmListViewV2.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import SwiftUI
import Swinject

struct AlgorithmListScreen: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: AlgorithmListScreenViewModel

    @State var showImporter = false

    init(folder: Folder) {
        let viewModel = Resolver.shared.resolve(AlgorithmListScreenViewModel.self, argument: folder)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            EmptyFolderMessageView()
                .alignVertically(.center)
                .padding(.bottom, 40)
                .opacity(viewModel.algorithms.isEmpty ? 1 : 0)

            List {
                ForEach(viewModel.filteredAlgorithms) { algorithm in
                    AlgorithmCellView(algorithm: algorithm) {
                        coordinator.push(.algorithm(algorithm))
                    }
                }.onDelete { indexSet in
                    withAnimation {
                        indexSet
                            .map { viewModel.filteredAlgorithms[$0] }
                            .forEach { viewModel.deleteAlgorithm($0) }
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .opacity(viewModel.algorithms.isEmpty ? 0 : 1)
            .toolbar {
                EditButton()
                Button("", systemImage: "square.and.arrow.up") {
                    showImporter.toggle()
                }
            }
        }
        .overlay(alignment: .bottom) {
            NewAlgorithmButton(action: viewModel.createAlgorithm)
        }
        .onAppear {
            viewModel.fetchAlgorithms()
        }
        .navigationTitle(viewModel.folder.name)
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.mtm],
            onCompletion: viewModel.importAlgorithm
        )
    }
}

#Preview {
    @StateObject var coordinator = Coordinator()
    let folder = Folder.sample
    return NavigationStack {
        AlgorithmListScreen(folder: folder)
    }.environmentObject(coordinator)
}
