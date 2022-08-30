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
            HStack {
                cellView("1")
                cellView("2", isSelected: true)
                cellView("3")
            }
            HStack {
                cellView("a")
                cellView("b", isSelected: true)
                cellView("c")
            }
            HStack {
                cellView("∆")
                cellView("ƒ", isSelected: true)
                cellView("~")
            }
        }.frame(width: 325, height: 325)
            .background(.white)
            .cornerRadius(40)
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
//            .scaleEffect(isSelected ? 1.07 : 1)
    }
}
