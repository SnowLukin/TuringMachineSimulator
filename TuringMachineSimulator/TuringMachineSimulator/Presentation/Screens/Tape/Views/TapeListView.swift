//
//  TapeListViewV2.swift
//  TuringMachine
//
//  Created by Snow Lukin on 10.12.2023.
//

import SwiftUI

struct TapeListView: View {

    @StateObject var viewModel: TapeListViewModel

    init(sharedStore: AlgorithmSharedStore) {
        let viewModel = Resolver.shared.resolve(TapeListViewModel.self, argument: sharedStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.tapes) { tape in
                VStack(spacing: 0) {
                    tapeName(tape.name)
                    tapeView(tape)
                }
            }
        }
        .padding(.vertical)
        .navigationTitle(viewModel.algorithm.name)
    }
}

extension TapeListView {
    @ViewBuilder
    func tapeName(_ name: String) -> some View {
        Text(name)
            .padding(.horizontal)
            .background(Color.secondaryBackground)
            .clipShape(.rect(topLeadingRadius: 6, topTrailingRadius: 6))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
    }

    @ViewBuilder
    func tapeView(_ tape: Tape) -> some View {
        TapeView(tape: tape) { headIndex in
            withAnimation {
                viewModel.updateTapeHeadIndex(
                    tape,
                    newHeadIndex: headIndex
                )
            }
        }
    }
}

#Preview {
    let algorithm = Algorithm.sample
    return AlgorithmScreen(algorithm: algorithm)
}
