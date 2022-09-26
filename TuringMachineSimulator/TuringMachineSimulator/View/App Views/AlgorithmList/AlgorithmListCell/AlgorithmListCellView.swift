//
//  AlgorithmListCellView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 26.09.2022.
//

import SwiftUI

struct AlgorithmListCellView: View {
    
    @ObservedObject var algorithm: Algorithm
    @StateObject private  var viewModel = AlgorithmListCellViewModel()
    
    var body: some View {
        NavigationLink {
            AlgorithmView(algorithm: algorithm)
        } label: {
            VStack(alignment: .leading) {
                Text(algorithm.wrappedName)
                    .font(.headline)
                    .lineLimit(1)
                Text(viewModel.getAlgorithmEditedTimeForTextView(algorithm.wrappedEditDate))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AlgorithmListCellView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        NavigationView {
            AlgorithmListCellView(algorithm: algorithm)
        }
    }
}
