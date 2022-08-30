//
//  TapeComponentView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI
import CoreData

class TapeComponentViewModel: ObservableObject {
    func changeHeadIndex(to component: TapeComponent, viewContext: NSManagedObjectContext) {
        guard let tape = component.tape else {
            print("Failed to get Tape from TapeComponent.")
            return
        }
        tape.headIndex = component.id
        
        guard let algorithm = tape.algorithm else {
            print("Failed to get Algorithm from TapeComponent.")
            return
        }
        algorithm.editDate = Date.now
        
        do {
            try viewContext.save()
            print("HeadIndex was changed successfully.")
        } catch {
            print("Failed changing headIndex.")
            print(error.localizedDescription)
        }
    }
}

struct TapeComponentView: View {
    
    @ObservedObject var tape: Tape
    @ObservedObject var component: TapeComponent
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TapeComponentViewModel()
    
    var body: some View {
        Button {
            viewModel.changeHeadIndex(to: component, viewContext: viewContext)
        } label: {
            Text(component.wrappedValue)
                .foregroundColor(
                    component.tape?.headIndex == component.id
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    component.tape?.headIndex == component.id
                    ? .blue
                    : Color(uiColor: .secondarySystemBackground)
                )
                .cornerRadius(35 / 2)
                .overlay(
                    Circle()
                        .stroke(.secondary)
                )
        }
    }
}

struct TapeComponentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        let tape = algorithm.wrappedTapes[0]
        let component = tape.wrappedComponents[0]
        TapeComponentView(tape: tape, component: component)
            .environment(\.managedObjectContext, context)
    }
}
