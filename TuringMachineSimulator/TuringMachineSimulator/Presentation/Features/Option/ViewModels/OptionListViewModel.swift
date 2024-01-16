//
//  OptionListViewModel.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 18.12.2023.
//

import SwiftUI
import Combine

final class OptionListViewModel: ObservableObject {
    private let repository: OptionRepository
    private var cancellables = Set<AnyCancellable>()

    @Published var options: [Option] = []
    @Published var state: MachineState
    @Published var searchText = ""

    var filteredOptions: [Option] {
        searchText.isEmpty
        ? options
        : options.filter { $0.joinedCombinations.contains(searchText) }
    }

    init(state: MachineState, repository: OptionRepository) {
        self.state = state
        self.repository = repository
    }

    func fetchOptions() {
        Task { @MainActor in
            do {
                let updatedOption = try await repository.getOptions(stateId: state.id)
                withAnimation {
                    options = updatedOption
                }
            } catch {
                AppLogger.error(error.localizedDescription)
            }
        }
    }

    func createOption(_ combinationText: String) {
        if combinationText.isEmpty { return }
        var combinations: [Combination] = []
        combinationText.forEach { char in
            let combination = Combination(fromChar: String(char))
            combinations.append(combination)
        }
        let option = Option(id: UUID().uuidString, toStateId: state.id, combinations: combinations)
        do {
            try repository.save(option: option, state: state)
            fetchOptions()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func deleteOption(_ option: Option) {
        do {
            try repository.delete(option: option)
            fetchOptions()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    func updateOption(_ option: Option) {
        do {
            try repository.update(option: option)
            fetchOptions()
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }
}
