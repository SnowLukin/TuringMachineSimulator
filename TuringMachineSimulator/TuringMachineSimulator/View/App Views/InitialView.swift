//
//  InitialView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
//        self.show(.primary)
        self.showsSecondaryOnlyButton = true
    }
}

struct InitialView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Folder.name, ascending: true)
        ],
        animation: .default)
    private var folders: FetchedResults<Folder>
    
    
    var body: some View {
        NavigationView {
            FolderListView()
            defaultDetailView()
            defaultSecondaryView()
        }.navigationViewStyle(.automatic)
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            NavigationView {
//                FolderListView()
//            }.navigationViewStyle(.stack)
//        } else {
//            NavigationView {
//                FolderListView()
//                defaultDetailView()
//                defaultSecondaryView()
//            }.navigationViewStyle(.automatic)
//        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension InitialView {
    @ViewBuilder
    private func defaultDetailView() -> some View {
        VStack {
            Text("No folder selected.")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Text("Please select folder in section on the left.")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }.padding(.horizontal)
            .navigationTitle("Algorithms")
    }
    
    @ViewBuilder
    private func defaultSecondaryView() -> some View {
        VStack {
            Text("No algorithm selected.")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Text("Please select algorithm in section on the left.")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }.padding(.horizontal)
    }
}
