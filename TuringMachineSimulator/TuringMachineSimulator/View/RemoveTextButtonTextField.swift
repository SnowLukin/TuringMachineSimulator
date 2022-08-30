//
//  RemoveTextButtonTextField.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 25.08.2022.
//

import SwiftUI

struct RemoveTextButtonTextField: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
            }
        }
    }
}
