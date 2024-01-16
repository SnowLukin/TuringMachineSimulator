//
//  ImportError.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import Foundation

enum ImportError: Error {
    case urlNotFound
    case dataAccessError(URL)
    case decodingError
    case securityScopeAccessError
    case other(Error)
    case errorWithMessage(String)
}

extension ImportError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .urlNotFound:
            return "No URL found in the result."
        case .dataAccessError(let url):
            return "Failed to access data from the URL: \(url)."
        case .decodingError:
            return "Failed to decode the algorithm from the file."
        case .securityScopeAccessError:
            return "Failed to access security scoped resource."
        case .other(let error):
            return error.localizedDescription
        case .errorWithMessage(let message):
            return message
        }
    }
}
