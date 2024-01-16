//
//  AppEnvironment.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 25.12.2023.
//

import Foundation

/// AppEnvironment is an enum that defines environments to further handle resolvings
enum AppEnvironment {
    /// Use .development environment in previews and while not working with coredata
    case development
    /// Use .production environment when need to work with coredata and for archives
    case production
}

/// Global environment variable
let environment: AppEnvironment = .development
