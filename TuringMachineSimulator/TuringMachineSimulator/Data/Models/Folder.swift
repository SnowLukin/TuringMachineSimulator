//
//  Folder.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 12.12.2023.
//

import Foundation

struct Folder: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let algorithms: [Algorithm]
}

extension Folder {
    init(entity: CDFolder) {
        id = entity.id.withDefaultValue("NAN")
        name = entity.name.withDefaultValue("NAN")
        algorithms = entity.unwrappedAlgorithms.map { Algorithm(entity: $0) }
    }

    func copy(name: String? = nil, algorithms: [Algorithm]? = nil) -> Folder {
        Folder(
            id: self.id,
            name: name ?? self.name,
            algorithms: algorithms ?? self.algorithms
        )
    }
}

extension Folder {
    static var sample: Folder {
        Folder(id: UUID().uuidString, name: "Sample Folder", algorithms: [Algorithm.sample])
    }
}
