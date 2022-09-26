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
    @State private var oldText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textfieldName()
            textfield()
        }
        .onAppear {
            text = purpose == .alphabet ? tape.wrappedAlphabet : tape.wrappedInput
        }
        .onChange(of: tape.wrappedAlphabet) { newValue in
            if purpose == .input {
                text = tape.wrappedInput
            }
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
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .font(.title3.bold())
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            .onChange(of: text) { newValue in
                print(newValue)
                if purpose == .alphabet {
                    viewModel.setNewAlphabetValue(text, for: tape, viewContext: viewContext)
                    text = tape.wrappedAlphabet
                } else {
                    text = newValue.replacingOccurrences(of: " ", with: "_")
                    viewModel.setNewInputValue(text, for: tape, viewContext: viewContext)
                    text = tape.wrappedInput
                }
            }
    }
}
