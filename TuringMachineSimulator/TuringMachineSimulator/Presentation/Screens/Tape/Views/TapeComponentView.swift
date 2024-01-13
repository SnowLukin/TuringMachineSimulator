//
//  TapeComponentView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct TapeComponentView: View {

    let value: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(value)
                .foregroundStyle(isActive ? .white : .secondary)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    isActive
                    ? Color.blue.shadow(.drop(radius: 1))
                    : Color.systemBackground.shadow(.drop(radius: 1))
                    , in: .rect(cornerRadius: isActive ? 30 : 10)
                )
        }
    }
}

#Preview {
    struct Container: View {
        @State var isActive = false
        var body: some View {
            TapeComponentView(value: "a", isActive: isActive) {
                withAnimation {
                    isActive.toggle()
                }
            }
        }
    }
    return Container()
}
