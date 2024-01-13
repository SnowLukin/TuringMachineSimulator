//
//  Resolver+Persistence.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation
import Swinject
import CoreData

extension Resolver {
    func injectPersistence() {
        container.register(NSPersistentContainer.self) { _ in
            PersistenceController.shared.container
        }
    }
}
