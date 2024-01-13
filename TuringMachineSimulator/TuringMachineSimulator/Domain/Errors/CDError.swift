//
//  CDError.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

enum CDError: Error {
    case errorWithMessage(String)
    case basicError(Error)
}

extension CDError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .errorWithMessage(let message):
            return message
        case .basicError(let error):
            return error.localizedDescription
        }
    }
}
