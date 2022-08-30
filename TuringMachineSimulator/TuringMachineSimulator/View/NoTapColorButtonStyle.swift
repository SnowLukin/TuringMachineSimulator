//
//  NoTapColorButtonStyle.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 25.08.2022.
//

import SwiftUI

struct NoTapColorButtonStyle: ButtonStyle {
    var colorScheme: ColorScheme
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                ? (colorScheme == .dark
                   ? Color(uiColor: .secondarySystemBackground)
                   : Color(uiColor: .systemBackground))
                : (colorScheme == .dark
                   ? Color(uiColor: .secondarySystemBackground)
                   : Color(uiColor: .systemBackground))
            )
    }
}
