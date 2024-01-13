//
//  Container+ViewModels.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation
import Swinject

// swiftlint:disable force_unwrapping identifier_name
extension Resolver {
    func injectViewModels() {
        injectSharedStores()
        injectFolderViewModels()
        injectAlgorithmViewModels()
        injectTapeViewModels()
        injectMachineStateViewModels()
        injectOptionViewModels()
        injectCombinationViewModels()
    }

    private func injectFolderViewModels() {
        container.register(FolderListScreenViewModel.self) { r in
            let repository = r.resolve(FolderRepository.self)!
            return FolderListScreenViewModel(folderRepository: repository)
        }
    }

    private func injectAlgorithmViewModels() {
        container.register(AlgorithmListScreenViewModel.self) { r, folder in
            let repository = r.resolve(AlgorithmRepository.self)!
            return AlgorithmListScreenViewModel(folder: folder, repository: repository)
        }

        container.register(AlgorithmViewModel.self) { (r, algorithm: Algorithm) in
            let sharedStore = r.resolve(AlgorithmSharedStore.self, argument: algorithm)!
            let algorithmRepository = r.resolve(AlgorithmRepository.self)!
            let machineStateRepository = r.resolve(MachineStateRepository.self)!
            return AlgorithmViewModel(
                sharedStore: sharedStore,
                algorithmRepository: algorithmRepository,
                machineStateRepository: machineStateRepository
            )
        }
    }

    private func injectTapeViewModels() {
        container.register(TapeListViewModel.self) { r, sharedStore in
            let repository = r.resolve(TapeRepository.self)!
            return TapeListViewModel(sharedStore: sharedStore, repository: repository)
        }

        container.register(TapeConfigListViewModel.self) { r, algorithm in
            let repository = r.resolve(TapeRepository.self)!
            return TapeConfigListViewModel(algorithm: algorithm, repository: repository)
        }
    }

    private func injectMachineStateViewModels() {
        container.register(MachineStateListViewModel.self) { r, algorithm in
            let stateRepository = r.resolve(MachineStateRepository.self)!
            let algorithmRepository = r.resolve(AlgorithmRepository.self)!
            return MachineStateListViewModel(
                algorithm: algorithm,
                stateRepository: stateRepository,
                algorithmRepository: algorithmRepository
            )
        }

        container.register(ActiveStateListViewModel.self) { r, algorithm in
            let repository = r.resolve(AlgorithmRepository.self)!
            return ActiveStateListViewModel(algorithm: algorithm, repository: repository)
        }
    }

    private func injectOptionViewModels() {

        container.register(OptionListViewModel.self) { r, state in
            let repository = r.resolve(OptionRepository.self)!
            return OptionListViewModel(state: state, repository: repository)
        }

        container.register(OptionDestinationMachineStateViewModel.self) { r, option, algorithm in
            let optionRepository = r.resolve(OptionRepository.self)!
            let stateRepository = r.resolve(MachineStateRepository.self)!
            return OptionDestinationMachineStateViewModel(
                option: option,
                algorithm: algorithm,
                optionRepository: optionRepository,
                stateRepository: stateRepository
            )
        }

        container.register(OptionViewModel.self) { (r, option: Option, algorithm) in
            let sharedStore = r.resolve(OptionSharedStore.self, argument: option)!
            let combinationRepository = r.resolve(CombinationRepository.self)!
            return OptionViewModel(
                sharedStore: sharedStore,
                algorithm: algorithm,
                combinationRepository: combinationRepository
            )
        }
    }

    private func injectCombinationViewModels() {
        container.register(CombinationListViewModel.self) { r, sharedStore in
            let repository = r.resolve(CombinationRepository.self)!
            return CombinationListViewModel(sharedStore: sharedStore, repository: repository)
        }
    }

    private func injectSharedStores() {
        container.register(AlgorithmSharedStore.self) { r, algorithm in
            let repository = r.resolve(AlgorithmRepository.self)!
            return AlgorithmSharedStore(algorithm: algorithm, repository: repository)
        }

        container.register(OptionSharedStore.self) { r, option in
            let repository = r.resolve(OptionRepository.self)!
            return OptionSharedStore(option: option, optionRepository: repository)
        }
    }
}
// swiftlint:enable force_unwrapping identifier_name
