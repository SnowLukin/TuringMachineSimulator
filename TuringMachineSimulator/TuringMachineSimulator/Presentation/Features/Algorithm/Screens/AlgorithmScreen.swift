//
//  AlgorithmScreen.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct AlgorithmScreen: View {

    @StateObject var viewModel: AlgorithmViewModel

    @State var showSettings = false
    @State var showInfo = false
    @State var showExport = false

    init(algorithm: Algorithm) {
        _viewModel = StateObject(
            wrappedValue: Resolver.shared.resolve(
                AlgorithmViewModel.self, argument: algorithm
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ConfigurationsView(
                    algorithm: viewModel.algorithm,
                    activeStateName: viewModel.activeStateName,
                    isOpened: $showSettings
                ).disabled(viewModel.algorithm.isChanged)

                ZStack {
                    VStack {
                        resetTag
                        Divider()
                        Text("Tapes")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .alignHorizontally(.leading)
                            .padding(.leading)
                        TapeListView(sharedStore: viewModel.sharedStore)
                            .shadow(radius: 1)
                            .disabled(viewModel.algorithm.isChanged)
                    }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            PlayStackView(viewModel: viewModel)
                .padding(20)
        }
        .onAppear {
            viewModel.fetchAlgorithm()
            showSettings = !viewModel.algorithm.isChanged
        }
        .onChange(of: viewModel.algorithm.isChanged) { newValue in
            if newValue {
                withAnimation(.bouncy) {
                    showSettings = false
                }
            }
        }
        .toolbar {
            Button {
                showExport.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .fileExporter(
            isPresented: $showExport,
            document: viewModel.documentManager,
            contentType: .mtm
        ) { result in
            switch result {
            case .success:
                AppLogger.info("File exported successfully.")
            case .failure(let failure):
                AppLogger.error(failure.localizedDescription)
            }
        }
    }
}

extension AlgorithmScreen {
    private var resetTag: some View {
        Text("Reset to enable configurations")
            .font(.caption.bold())
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(height: viewModel.algorithm.isChanged ? 30 : 0)
            .background(
                .red,
                in: .rect(topLeadingRadius: 8, bottomLeadingRadius: 8)
            )
            .alignHorizontally(.trailing)
            .offset(x: viewModel.algorithm.isChanged ? 0 : 300)
            .opacity(viewModel.algorithm.isChanged ? 1 : 0)
    }

    private var toolbarButtons: some View {
        Group {
            Button {
                showExport.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
            }.disabled(viewModel.algorithm.isChanged)

            Button {
                showInfo.toggle()
            } label: {
                Image(systemName: "info.circle")
            }.disabled(viewModel.algorithm.isChanged)
        }
    }
}

#Preview {
    let algorithm = Algorithm.sample
    return NavigationStack {
        AlgorithmScreen(algorithm: algorithm)
    }
}
