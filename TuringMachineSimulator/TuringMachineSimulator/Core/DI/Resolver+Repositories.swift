//
//  Container+Services.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation
import Swinject
import CoreData

// swiftlint:disable force_unwrapping identifier_name
extension Resolver {
    func injectRepositories() {

        container.register(CombinationRepository.self) { r in
            if environment == .development { return FakeCombinationRepository() }
            let persistentContainer = r.resolve(NSPersistentContainer.self)!
            return DefaultCombinationRepository(persistentContainer: persistentContainer)
        }

        container.register(OptionRepository.self) { r in
            if environment == .development { return FakeOptionRepository() }
            let persistentContainer = r.resolve(NSPersistentContainer.self)!
            let combinationRepository = r.resolve(CombinationRepository.self)!
            return DefaultOptionRepository(persistentContainer: persistentContainer,
                                           combinationRepository: combinationRepository)
        }

        container.register(MachineStateRepository.self) { r in
            if environment == .development { return FakeMachineStateRepository() }
            let persistentContainer = r.resolve(NSPersistentContainer.self)!
            let optionRepository = r.resolve(OptionRepository.self)!
            return DefaultMachineStateRepository(persistentContainer: persistentContainer,
                                                 optionRepository: optionRepository)
        }

        container.register(TapeRepository.self) { r in
            if environment == .development { return FakeTapeRepository() }
            let persistentContainer = r.resolve(NSPersistentContainer.self)!
            return DefaultTapeRepository(persistentContainer: persistentContainer)
        }

        container.register(AlgorithmRepository.self) { r in
            if environment == .development { return FakeAlgorithmRepository() }
            let persistentContainer = r.resolve(NSPersistentContainer.self)!
            let tapeRepository = r.resolve(TapeRepository.self)!
            let machineStateRepository = r.resolve(MachineStateRepository.self)!
            return DefaultAlgorithmRepository(persistentContainer: persistentContainer,
                                              tapeRepository: tapeRepository,
                                              machineStateRepository: machineStateRepository)
        }

        container.register(FolderRepository.self) { r in
            if environment == .development { return FakeFolderRepository() }
            let persistentContainer = r.resolve(NSPersistentContainer.self)!
            let algorithmRepository = r.resolve(AlgorithmRepository.self)!
            return DefaultFolderRepository(persistentContainer: persistentContainer,
                                           algorithmRepository: algorithmRepository)
        }
    }
}
// swiftlint:enable force_unwrapping identifier_name
