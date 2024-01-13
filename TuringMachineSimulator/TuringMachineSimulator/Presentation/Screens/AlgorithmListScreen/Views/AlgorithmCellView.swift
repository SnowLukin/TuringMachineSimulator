//
//  AlgorithmCellView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct AlgorithmCellView: View {
    let algorithm: Algorithm
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(algorithm.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.blue)
                Text(algorithm.lastEditDate.algorithmFormat())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .alignHorizontally(.leading)
            .contentShape(.rect)
        }.buttonStyle(.plain)
    }
}

#Preview {
    let algorithm = Algorithm(
        id: UUID().uuidString,
        name: "Test Algorithm",
        algDescription: "",
        createdDate: .now,
        lastEditDate: .now,
        startingStateId: "",
        activeStateId: "",
        tapes: [],
        states: []
    )
    return List {
        AlgorithmCellView(algorithm: algorithm) {}
    }
}

private extension Date {
    func algorithmFormat() -> String {
        if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        }
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: self)
        }
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: self)
    }
}
