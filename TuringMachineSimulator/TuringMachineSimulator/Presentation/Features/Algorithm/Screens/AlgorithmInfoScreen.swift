//
//  AlgorithmInfoScreen.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 18.01.2024.
//

import SwiftUI

struct AlgorithmInfoScreen: View {

    @State var nameTF = ""
    @State var descriptionTF = ""

    @StateObject var viewModel: AlgorithmInfoViewModel

    init(algorithm: Algorithm) {
        let viewModel = Resolver.shared.resolve(AlgorithmInfoViewModel.self, argument: algorithm)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            TextField("Algorithm Name", text: $nameTF)
                .padding()
                .background(Color.secondaryBackground, in: .rect(cornerRadius: 10))
                .padding(.horizontal)
            TextEditor(text: $descriptionTF)
                .scrollContentBackground(.hidden)
                .padding(10)
                .background(Color.secondaryBackground, in: .rect(cornerRadius: 10))
                .padding(.horizontal)
        }
        .padding(.vertical)
        .onAppear {
            nameTF = viewModel.algorithm.name
            descriptionTF = viewModel.algorithm.algDescription
        }
        .onChange(of: nameTF) { newValue in
            viewModel.updateName(newValue)
        }
        .onChange(of: descriptionTF) { newValue in
            viewModel.updateDescription(newValue)
        }
        .navigationTitle("Info")
    }
}

#Preview {
    let algorithm = Algorithm.sample
    return NavigationStack {
        AlgorithmInfoScreen(algorithm: algorithm)
    }
}
