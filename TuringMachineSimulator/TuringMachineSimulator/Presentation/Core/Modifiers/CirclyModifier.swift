//
//  CirclyModifier.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct CirclyModifier: ViewModifier {
    let foreground: Color
    let background: Color
    func body(content: Content) -> some View {
        content
            .fontWeight(.semibold)
            .foregroundStyle(foreground)
            .frame(width: 55, height: 55)
            .background(background, in: .circle)
    }
}

extension View {
    func makeCircly(
        foreground: Color = .white,
        background: Color = .blue
    ) -> some View {
        self.modifier(
            CirclyModifier(foreground: foreground,
                           background: background)
        )
    }
}
