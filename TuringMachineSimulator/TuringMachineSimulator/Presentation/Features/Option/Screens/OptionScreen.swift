//
//  OptionScreen.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 24.12.2023.
//

import SwiftUI

struct OptionScreen: View {
    @EnvironmentObject var coordinator: Coordinator

    @StateObject var viewModel: OptionViewModel

    init(option: Option, algorithm: Algorithm) {
        let viewModel = Resolver.shared.resolve(
            OptionViewModel.self,
            arg1: option, arg2: algorithm
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack {
                section("Destination State")
                Button {
                    coordinator.push(.optionDestinationState(viewModel.option, viewModel.algorithm))
                } label: {
                    HStack {
                        Text(viewModel.destinationStateName)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .alignHorizontally(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.blue.gradient, in: .rect(cornerRadius: 10))
                    .padding(.horizontal)
                }
                Divider()
                section("Configurations")
                CombinationConfigListView(sharedStore: viewModel.sharedStore)

                Button {
                    withAnimation {
                        viewModel.createCombination()
                    }
                } label: {
                    Text("Add combination")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .alignHorizontally(.center)
                        .padding()
                        .background(.blue, in: .rect(cornerRadius: 10))
                        .padding()
                }
            }.padding(.vertical)
        }
        .onAppear {
            viewModel.fetchOption()
        }
        .navigationTitle("Combination: \(viewModel.option.joinedCombinations)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    OptionScreen(option: Option.sample(), algorithm: Algorithm.sample)
}

extension OptionScreen {
    @ViewBuilder
    private func section(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .alignHorizontally(.leading)
            .padding(.horizontal)
    }
}
