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
                .opacity(viewModel.algorithms.isEmpty && !viewModel.showLoader ? 1 : 0)

            List {
                ForEach(viewModel.filteredAlgorithms) { algorithm in
                    AlgorithmCellView(algorithm: algorithm) {
                        coordinator.push(.algorithm(algorithm))
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        indexSet
                            .map { viewModel.filteredAlgorithms[$0] }
                            .forEach { viewModel.deleteAlgorithm($0) }
                    }
                }
                .animation(.default, value: viewModel.filteredAlgorithms)
            }.animation(.default, value: viewModel.filteredAlgorithms)
            .searchable(text: $viewModel.searchText)
            .opacity(viewModel.algorithms.isEmpty ? 0 : 1)
            .toolbar {
                Button("", systemImage: "square.and.arrow.down") {
                    showImporter.toggle()
                }
                EditButton()
            }
        }
        .overlay(alignment: .bottom) {
            NewAlgorithmButton(action: viewModel.createAlgorithm)
        }
        .overlay {
            if viewModel.showLoader {
                ProgressView("Importing Algorithm")
            }
        }
        .disabled(viewModel.showLoader)
        .onAppear {
            viewModel.fetchAlgorithms()
        }
        .navigationBarBackButtonHidden(viewModel.showLoader)
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
