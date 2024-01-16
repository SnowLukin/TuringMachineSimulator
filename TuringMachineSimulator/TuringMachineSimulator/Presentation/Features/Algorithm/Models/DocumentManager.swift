//
//  DocumentManager.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentManager: FileDocument {

    static var readableContentTypes: [UTType] { [ .mtm ] }

    var algorithm: Algorithm

    init(algorithm: Algorithm) {
        self.algorithm = algorithm
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let dataAlgorithm = try? JSONDecoder().decode(Algorithm.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        algorithm = dataAlgorithm
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encodedData = try JSONEncoder().encode(algorithm)
        let fileWrapper = FileWrapper(regularFileWithContents: encodedData)
        return fileWrapper
    }
}

extension UTType {
    static var mtm: UTType {
        UTType(importedAs: "com.SnowLukin.TuringMachine.TuringMachineData")
    }
}
