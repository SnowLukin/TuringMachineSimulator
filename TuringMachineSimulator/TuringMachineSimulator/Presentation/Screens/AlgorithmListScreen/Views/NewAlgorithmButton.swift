//
//  NewAlgorithmButton.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct NewAlgorithmButton: View {

    @State var showNewAlgorithmAlert = false

    let action: (String) -> Void

    var body: some View {
        Button {
            showNewAlgorithmAlert.toggle()
        } label: {
            Image(systemName: "doc.badge.plus")
                .font(.title2)
        }
        .alignHorizontally(.trailing)
        .padding()
        .background(.ultraThickMaterial)
        .alert("New Algorithm", isPresented: $showNewAlgorithmAlert) {
            TextFieldAlert(placeholder: "Algorithm name", action: action)
        }
    }
}

#Preview {
    NewAlgorithmButton {_ in }
}
