//
//  AlgorithmView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct AlgorithmView: View {
    
    @ObservedObject var algorithm: Algorithm
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = AlgorithmViewModel()
    @State private var isChanged = false
    @State private var showSettings = false
    @State private var showEditAlgorithmNameAlert = false
    @State private var algorithmNameText = ""
    @State private var showInfo = false
    @State private var showExport = false
    
    var body: some View {
        ZStack {
            VStack {
                ConfigurationsView(algorithm: algorithm, showSettings: $showSettings)
                    .disabled(isChanged)
                    if isChanged {
                        Text("Reset to enable configurations")
                            .font(.body)
                            .foregroundColor(.red)
                    }
                    
                    TapesWorkView(algorithm: algorithm)
                        .shadow(radius: 1)
            }
            PlayStackView(algorithm: algorithm, isChanged: $isChanged)
        }
        .navigationTitle(algorithm.wrappedName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        showExport.toggle()
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        showInfo = true
                    }
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .onAppear {
            algorithmNameText = algorithm.wrappedName
        }
        .onChange(of: isChanged) { _ in
            if isChanged {
                withAnimation {
                    showSettings = false
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            AlgorithmInfoView(algorithm: algorithm)
        }
        .fileExporter(
            isPresented: $showExport,
            document: DocumentManager(algorithm: viewModel.convertToShared(algorithm)),
            contentType: .mtm
        ) { result in
            switch result {
            case .success:
                print("File successfully exported")
            case .failure:
                print("Error. Failed exporting the file.")
            }
        }
    }
}

struct AlgorithmView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        NavigationView {
            AlgorithmView(algorithm: algorithm)
                .environment(\.managedObjectContext, context)
        }
    }
}
