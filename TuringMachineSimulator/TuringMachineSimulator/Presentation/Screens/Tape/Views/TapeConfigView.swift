//
//  TapeConfigView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct TapeConfigView: View {

    let tape: Tape
    let onUpdate: (String) -> Void
    let onDelete: () -> Void

    @State var inputTF = ""

    var body: some View {
        VStack(spacing: 15) {
            Text(tape.name)
                .font(.title.bold())
                .foregroundStyle(.gray)
                .alignHorizontally(.leading)

            VStack(spacing: 5) {
                Text("Input")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .alignHorizontally(.leading)
                TextField("Tapes input", text: $inputTF)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding()
                    .background(Color.tertiaryBackground, in: .rect(cornerRadius: 10))
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                onDelete()
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(.red.gradient)
                    .clipShape(.circle)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .onAppear {
            inputTF = tape.trimmedInput
        }
        .onChange(of: inputTF) { newValue in
            onUpdate(newValue)
        }
    }
}

#Preview {
    let tape = Tape.sample
    return TapeConfigView(tape: tape) {_ in

    } onDelete: {

    }
}
