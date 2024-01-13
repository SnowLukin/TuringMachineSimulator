//
//  Resolver.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation
import Swinject
import CoreData

// swiftlint:disable force_unwrapping

/// Resolver is a singleton class that is responsible for injecting all dependencies in the app.
final class Resolver {

    /// The shared instance of the resolver.
    static let shared = Resolver()

    /// The container that holds all the dependencies.
    private(set) var container = Container()

    /// This method is responsible for injecting all dependencies in the app.
    ///
    /// It should be called only once in the app's lifecycle.
    @MainActor
    func injectModules() {
        injectPersistence()
        injectRepositories()
        injectViewModels()
    }

    /// This method is responsible for resolving a dependency.
    ///
    /// - Parameter type: The type of the dependency to be resolved.
    /// - Parameter name: The name of the dependency to be resolved.
    /// - Returns: The resolved dependency.
    func resolve<T>(_ type: T.Type, name: String? = nil) -> T {
        container.resolve(T.self, name: name)!
    }

    /// This method is responsible for resolving a dependency with argument.
    ///
    /// - Parameter type: The type of the dependency to be resolved.
    /// - Parameter name: The name of the dependency to be resolved.
    /// - Parameter argument: The argument of the dependency to be resolved.
    /// - Returns: The resolved dependency.
    func resolve<T, Arg>(_ type: T.Type, name: String? = nil, argument: Arg) -> T {
        container.resolve(type, name: name, argument: argument)!
    }

    /// This method is responsible for resolving a dependency with 2 arguments.
    func resolve<T, Arg1, Arg2>(_ type: T.Type, name: String? = nil, arg1: Arg1, arg2: Arg2) -> T {
        container.resolve(type, name: name, arguments: arg1, arg2)!
    }
}
// swiftlint:enable force_unwrapping
