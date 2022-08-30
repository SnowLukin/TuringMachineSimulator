//
//  InputView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 25.08.2022.
//

import SwiftUI

struct InputView: View {
    enum Purpose {
        case alphabet
        case input
    }
    
    @ObservedObject var tape: Tape
    let purpose: Purpose
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = InputViewModel()
    @State private var text = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textfieldName()
            textfield()
        }
        .onAppear {
            text = purpose == .alphabet ? tape.wrappedAlphabet : tape.wrappedInput
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        InputView(tape: tape, purpose: .alphabet)
            .environment(\.managedObjectContext, context)
    }
}

extension InputView {
    @ViewBuilder
    private func textfieldName() -> some View {
        Text(purpose == .alphabet ? "Alphabet" : "Input")
            .fontWeight(.semibold)
    }
    
    @ViewBuilder
    private func textfield() -> some View {
        TextField("", text: $text)
            .font(.title3.bold())
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            .onChange(of: text) { newValue in
                if purpose == .alphabet {
                    if newValue.last == " " {
                        text.removeLast()
                    }
                    viewModel.setNewAlphabetValue(text, for: tape, viewContext: viewContext)
                } else {
                    if newValue.last == " " {
                        text.removeLast()
                        text.append("_")
                    }
                    viewModel.setNewInputValue(text, for: tape, viewContext: viewContext)
                }
            }
            .onChange(of: tape.alphabet) { _ in
                if purpose == .alphabet {
                    text = tape.wrappedAlphabet
                }
            }
            .onChange(of: tape.input) { _ in
                if purpose == .input {
                    text = tape.wrappedInput
                }
            }
            .modifier(RemoveTextButtonTextField(text: $text))
    }
}
