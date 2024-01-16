//
//  TapeComponentsLineView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct TapeComponentsLineView: View {

    let tape: Tape
    let action: (Int) -> Void

    var workingInputArray: [String] {
        tape.workingInput.map { String($0) }
    }

    var body: some View {
        LazyHStack {
            ForEach(workingInputArray.indices, id: \.self) { index in
                let component = workingInputArray[index]
                let isActive = tape.workingHeadIndex == index
                TapeComponentView(value: component, isActive: isActive) {
                    action(index)
                }
                .id(index)
            }
        }
    }
}

#Preview {
    TapeComponentsLineView(tape: Tape.sample) {_ in }
}
