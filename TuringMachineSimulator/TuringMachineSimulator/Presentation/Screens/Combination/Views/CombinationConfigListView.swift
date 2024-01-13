//
//  CombinationConfigListView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 24.12.2023.
//

import SwiftUI

struct CombinationConfigListView: View {

    @StateObject var viewModel: CombinationListViewModel

    init(sharedStore: OptionSharedStore) {
        let viewModel = Resolver.shared.resolve(CombinationListViewModel.self, argument: sharedStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ForEach(viewModel.combinations) { combination in
                HStack(alignment: .bottom) {
                    Text("From \(combination.fromChar) to \(combination.toChar)")
                        .foregroundColor(Color.gray)
                        .alignHorizontally(.leading)
                    Button {
                        withAnimation {
                            viewModel.deleteCombination(combination)
                        }
                    } label: {
                        Text("Remove")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.red.gradient, in: .rect(cornerRadius: 5))
                    }.alignHorizontally(.trailing)
                }
                .padding(.horizontal)
                CombinationView(combination: combination) { updatedCombination in
                    viewModel.updateCombination(updatedCombination)
                }
            }
        }
    }
}

#Preview {
    OptionView(option: Option.sample(), algorithm: Algorithm.sample)
}
