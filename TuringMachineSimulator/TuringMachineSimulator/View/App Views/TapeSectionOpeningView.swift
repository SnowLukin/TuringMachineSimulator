//
//  TapeSectionOpeningView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct TapeSectionOpeningView: View {
    
    @ObservedObject var tape: Tape
    
    @State private var isOpened = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Tape \(tape.wrappedID)")
                        .font(.system(size: 35).bold())
                        .foregroundColor(.gray)
                    Spacer()
                    Button {
                        withAnimation {
                            isOpened.toggle()
                        }
                    } label: {
                        Text(isOpened ? "Hide" : "Show")
                    }
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding([.top, .bottom], 9)
                .padding([.leading, .trailing], 30)
                
                if isOpened {
                    TapeConfigView(tape: tape)
                        .shadow(radius: 5)
                        .padding(.bottom)
                }
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .padding([.leading, .trailing])
    }
}

struct TapeSectionOpeningView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        TapeSectionOpeningView(tape: tape)
            .environment(\.managedObjectContext, context)
    }
}
