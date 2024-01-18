//
//  Page.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

enum Page: Identifiable {
    case folderList
    case folder(Folder)
    case algorithm(Algorithm)
    case tapeConfig(Algorithm)
    case stateList(Algorithm)
    case optionList(MachineState, Algorithm)
    case option(Option, Algorithm)
    case optionDestinationState(Option, Algorithm)
    case activeStateList(Algorithm)
    case algorithmInfo(Algorithm)

    var id: String {
        switch self {
        case .folderList:
            "folderList"
        case .folder:
            "folder"
        case .algorithm:
            "algorithm"
        case .tapeConfig:
            "tapeConfig"
        case .stateList:
            "stateList"
        case .optionList:
            "optionList"
        case .option:
            "option"
        case .optionDestinationState:
            "optionDestinationState"
        case .activeStateList:
            "activeStateList"
        case .algorithmInfo:
            "algorithmInfo"
        }
    }
}

extension Page: Hashable {
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
