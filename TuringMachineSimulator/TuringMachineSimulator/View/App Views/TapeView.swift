//
//  TapeView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct TapeView: View {
    
    @ObservedObject var tape: Tape
    @State private var text: String = "-"
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                tapeGrid
                    .onAppear {
                        text = String(tape.wrappedHeadIndex)
                        withAnimation {
                            value.scrollTo(tape.wrappedHeadIndex, anchor: .center)
                        }
                    }
                    .onChange(of: tape.wrappedHeadIndex) { newValue in
                        text = String(newValue)
                        withAnimation {
                            value.scrollTo(newValue, anchor: .center)
                        }
                    }
            }
        }
        .frame(height: 40)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(9)
    }
}

struct TapeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        TapeView(tape: tape)
            .environment(\.managedObjectContext, context)
    }
}

extension TapeView {
    @ViewBuilder
    private var tapeGrid: some View {
        LazyHGrid(rows: [GridItem(.flexible(minimum: 25))]) {
            ForEach(tape.wrappedComponents) { component in
                TapeComponentView(tape: tape, component: component)
                    .id(component.wrappedID)
            }
        }
        .padding(.horizontal)
    }
}
