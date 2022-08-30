//
//  TapeConfigView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI


struct TapeConfigView: View {
    
    @ObservedObject var tape: Tape
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TapeConfigViewModel()
    @State private var isConfigShown = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 0) {
                ZStack {
                    HStack {
                        if !isConfigShown {
                            removeButton()
                            Spacer()
                        }
                        if isConfigShown {
                            configTape()
                                .padding(.bottom)
                        }
                        configButton()
                            .padding(.trailing, 10)
                            .padding(.bottom, 5)
                    }
                }
                TapeView(tape: tape)
            }.padding(.horizontal)
        }
    }
}

struct TapeConfigView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        TapeConfigView(tape: tape)
            .environment(\.managedObjectContext, context)
    }
}

extension TapeConfigView {
    @ViewBuilder
    private func configTape() -> some View {
        VStack {
            VStack {
                InputView(tape: tape, purpose: .alphabet)
                InputView(tape: tape, purpose: .input)
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(20)
        }
    }
    
    @ViewBuilder
    private func removeButton() -> some View {
        Button {
            withAnimation {
                viewModel.deleteTape(tape, viewContext: viewContext)
            }
        } label: {
            Text("Remove")
                .animation(.easeInOut, value: !isConfigShown)
        }
        .disabled(tape.algorithm?.wrappedTapes.count ?? 0 < 2)
    }
    
    @ViewBuilder
    private func configButton() -> some View {
        Button {
            withAnimation(.default) {
                isConfigShown.toggle()
            }
        } label: {
            ZStack {
                Color(uiColor: .secondarySystemBackground)
                Image(systemName: !isConfigShown ? "plus" : "xmark")
                    .font(.title3)
            }
            .frame(width: 30, height: 30)
            .clipShape(Circle())
        }
    }
}
