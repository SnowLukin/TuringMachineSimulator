//
//  TapeView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct TapeView: View {

    let tape: Tape
    let action: (Int) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                TapeComponentsLineView(tape: tape, action: action)
                    .padding(.horizontal)
            }
            .onAppear {
                scrollToHeadIndex(tape.workingHeadIndex, in: proxy)
            }
            .onChange(of: tape) { newValue in
                withAnimation {
                    scrollToHeadIndex(newValue.workingHeadIndex, in: proxy)
                }
            }
        }
        .frame(height: 55)
        .background(Color.secondaryBackground)
    }

    private func scrollToHeadIndex(_ index: Int, in proxy: ScrollViewProxy) {
        proxy.scrollTo(index, anchor: .center)
    }
}

#Preview {
    struct Container: View {
        @State var tape: Tape
        var body: some View {
            TapeView(tape: tape) { index in
                tape = Tape(name: tape.name, input: tape.input, headIndex: index)
            }
        }
    }
    return Container(tape: Tape.sample)
}
