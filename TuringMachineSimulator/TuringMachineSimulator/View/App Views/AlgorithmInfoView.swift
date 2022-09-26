//
//  AlgorithmInfoView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import SwiftUI
import CoreData

class AlgorithmInfoViewModel: ObservableObject {
    func updateName(_ name: String, for algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        algorithm.name = name
        algorithm.editDate = Date.now
        do {
            try viewContext.save()
            print("New name saved successfully.")
        } catch {
            print("Failed saving new name.")
            print(error.localizedDescription)
        }
    }
    
    func updateDescription(_ value: String, for algorithm: Algorithm, viewContext: NSManagedObjectContext) {
        algorithm.algDescription = value
        algorithm.editDate = Date.now
        do {
            try viewContext.save()
            print("New name saved successfully.")
        } catch {
            print("Failed saving new name.")
            print(error.localizedDescription)
        }
    }
}

struct AlgorithmInfoView: View {
    
    enum Focus {
        case name
        case description
    }
    
    @ObservedObject var algorithm: Algorithm
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = AlgorithmInfoViewModel()
    @FocusState private var focus: Focus?
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Placeholder", text: $name)
                        .focused($focus, equals: .name)
                }
                
                Section("Description") {
                    ZStack {
                        TextEditor(text: $description)
                            .focused($focus, equals: .description)
                        Text(description).opacity(0).padding(.all, 8)
                    }
                }
                .onAppear {
                    name = algorithm.wrappedName
                    description = algorithm.wrappedDescription
                }
            }
            .navigationTitle("Algorithm info")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focus = nil
                    }
                }
            }
            .onChange(of: name) { newValue in
                if name.count > 20 {
                    name.removeLast()
                }
                viewModel.updateName(name, for: algorithm, viewContext: viewContext)
            }
            .onChange(of: description) { newValue in
                viewModel.updateDescription(description, for: algorithm, viewContext: viewContext)
            }
        }
    }
}

struct AlgorithmInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        AlgorithmInfoView(algorithm: algorithm)
            .environment(\.managedObjectContext, context)
    }
}
