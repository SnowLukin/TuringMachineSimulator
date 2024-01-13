//
//  NewFolderButton.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct NewFolderButton: View {

    @State private var showNewFolderAlert = false

    let action: (String) -> Void

    var body: some View {
        Button {
            showNewFolderAlert.toggle()
        } label: {
            Image(systemName: "folder.badge.plus")
                .font(.title2)
        }
        .alignHorizontally(.leading)
        .padding()
        .alert("New Folder", isPresented: $showNewFolderAlert) {
            TextFieldAlert(placeholder: "Folder name", action: action)
        }
    }
}

#Preview {
    NewFolderButton { _ in }
        .alignVertically(.bottom)
}
