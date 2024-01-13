//
//  LogoView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 30.08.2022.
//

import SwiftUI

struct LogoView: View {

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                row(values: ["1", "2", "3"])
                row(values: ["a", "b", "c"])
                row(values: ["∆", "ƒ", "~"])
            }
            .frame(width: 325, height: 325)
            .background(.white, in: .rect(cornerRadius: 40))
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}

extension LogoView {

    @ViewBuilder
    private func row(values: [String], selectedIndex: Int = 1) -> some View {
        HStack {
            ForEach(0..<values.count, id: \.self) { index in
                cellView(values[index], isSelected: index == selectedIndex)
            }
        }
    }

    @ViewBuilder
    private func cellView(_ value: String, isSelected: Bool = false) -> some View {
        Text(value)
            .font(.system(size: 40, weight: .semibold, design: .rounded))
            .foregroundColor(isSelected ? .white : .black)
            .frame(width: 80, height: 80)
            .background(
                isSelected
                ? Color.blue.opacity(0.7)
                : Color(uiColor: .secondarySystemBackground)
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(
                        .gray,
                        lineWidth: 5
                    )
            )
    }
}
