//
//  FolderCellView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct FolderCellView: View {

    let folder: Folder
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "folder")
                    .foregroundStyle(.orange)
                    .font(.title2)
                Text(folder.name)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                    .alignHorizontally(.leading)
                Text("\(folder.algorithms.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }.contentShape(.rect)
        }.buttonStyle(.plain)
    }
}

#Preview {
    let folder = Folder(id: UUID().uuidString, name: "Test Folder", algorithms: [])
    return List {
        FolderCellView(folder: folder) {}
    }
}
