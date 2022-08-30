//
//  TapesWorkView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct RoundedCornersBackground: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct TapesWorkView: View {
    
    @ObservedObject var algorithm: Algorithm
    
    var body: some View {
//        ScrollView {
            ForEach(algorithm.wrappedTapes) { tape in
                VStack(spacing: 0) {
                    setTapeNameText(tapeID: tape.wrappedID)
                    TapeView(tape: tape)
                        .padding([.leading, .trailing])
                }
            }
//        }
    }
}

struct TapesWorkView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        TapesWorkView(algorithm: algorithm)
            .environment(\.managedObjectContext, context)
    }
}

extension TapesWorkView {
    @ViewBuilder
    private func setTapeNameText(tapeID: Int) -> some View {
        HStack {
            Text("Tape \(tapeID)")
                .padding([.leading, .trailing])
                .background(
                    RoundedCornersBackground(corners: [.topLeft, .topRight], radius: 6)
                        .fill(Color(uiColor: .secondarySystemBackground))
                )
                .padding([.leading], 8)
            Spacer()
        }.padding(.leading)
    }
}
