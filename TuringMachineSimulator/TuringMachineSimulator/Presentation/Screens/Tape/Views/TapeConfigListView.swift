//
//  TapeConfigListView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct TapeConfigListView: View {

    @StateObject var viewModel: TapeConfigListViewModel
    @State var showNewTapeAlert = false

    init(algorithm: Algorithm) {
        let viewModel = Resolver.shared.resolve(TapeConfigListViewModel.self, argument: algorithm)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.tapes) { tape in
                    TapeConfigView(tape: tape) { newInput in
                        withAnimation {
                            viewModel.updateTapeWithInput(tape, newInput: newInput)
                        }
                    } onDelete: {
                        withAnimation {
                            viewModel.deleteTape(tape)
                        }
                    }
                }
            }
        }
        .animation(.spring, value: viewModel.tapes)
        .toolbar {
            Button("Add Tape") {
                showNewTapeAlert.toggle()
            }
        }
        .alert("New tape", isPresented: $showNewTapeAlert) {
            TextFieldAlert(placeholder: "Tape name") { tapeName in
                withAnimation {
                    viewModel.createTape(tapeName)
                }
            }
        }
        .navigationTitle("Tapes")
    }
}

#Preview {
    RootView()
}
