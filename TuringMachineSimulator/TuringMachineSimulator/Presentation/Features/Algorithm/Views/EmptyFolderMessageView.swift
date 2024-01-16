//
//  EmptyFolderMessageView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct EmptyFolderMessageView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Folder is empty")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Text("You can add algorithms by clicking document icon below")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }.padding(.horizontal)
    }
}

#Preview {
    EmptyFolderMessageView()
}
