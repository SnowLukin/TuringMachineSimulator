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
            VStack {
                Image(systemName: "folder.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .foregroundStyle(.blue)
                Text(folder.name)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                Text("Algorithms: \(folder.algorithms.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }.buttonStyle(.plain)
    }
}

#Preview {
    let folder = Folder(id: UUID().uuidString, name: "Test Folder", algorithms: [])
    return HStack(spacing: 20) {
        FolderCellView(folder: folder) {}
        FolderCellView(folder: folder) {}
    }
}
