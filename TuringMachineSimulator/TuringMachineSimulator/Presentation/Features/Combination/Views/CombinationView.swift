//
//  CombinationView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 24.12.2023.
//

import SwiftUI

struct CombinationView: View {

    let combination: Combination
    let onUpdate: (Combination) -> Void

    @State var fromChar: String
    @State var toChar: String
    @State var currentDirection: Direction

    init(combination: Combination, onUpdate: @escaping (Combination) -> Void) {
        self.combination = combination
        self.onUpdate = onUpdate
        self.fromChar = combination.fromChar
        self.toChar = combination.toChar
        self.currentDirection = combination.direction
    }

    var body: some View {
        HStack(spacing: 0) {
            TextField("fromChar", text: $fromChar)
                .submitLabel(.done)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Divider()
            Menu {
                ForEach(Direction.allCases) { direction in
                    Button {
                        withAnimation {
                            currentDirection = direction
                            onUpdate(combination.copy(direction: direction))
                        }
                    } label: {
                        Label {
                            Text(direction.id)
                        } icon: {
                            direction.image
                        }
                    }
                }
            } label: {
                currentDirection.image
                    .frame(width: 50, height: 50)
            }
            Divider()
            TextField("toChar", text: $toChar)
                .submitLabel(.done)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .onChange(of: fromChar) { newValue in
            fromChar = newValue.limitToOne()
            let newValue = newValue.limitToOne()
            onUpdate(combination.copy(fromChar: newValue))
        }
        .onChange(of: toChar) { newValue in
            toChar = newValue.limitToOne()
            let newValue = newValue.limitToOne()
            onUpdate(combination.copy(toChar: newValue))
        }
    }
}

#Preview {
    CombinationView(combination: Combination.sample) {_ in}
}

private extension String {
    func limitToOne() -> String {
        String(self.prefix(1))
    }
}
