//
//  TextFieldAlert.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct TextFieldAlert: View {

    let placeholder: String
    let action: (String) -> Void

    @State private var text = ""

    var body: some View {
        Group {
            TextField(placeholder, text: $text)
            Button("Cancel", role: .cancel) {}
            Button("OK") {
                action(text)
                text.removeAll()
            }
        }
    }
}
