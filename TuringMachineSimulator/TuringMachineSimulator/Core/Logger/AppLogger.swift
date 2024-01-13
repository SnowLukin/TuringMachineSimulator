//
//  AppLogger.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 31.12.2023.
//

import Foundation
import OSLog

/// `AppLogger` is an enumeration that provides a simple logging utility for your application.
/// It supports different log types and integrates with the system's OSLog.
enum AppLogger {

    /// `LogType` defines different types of log messages, such as info, warning, and error.
    /// Each type has a unique prefix to differentiate in logs.
    enum LogType: String {
        case info
        case warning
        case error

        var prefix: String {
            switch self {
            case .info: "[INFO]"
            case .warning: "[WARNING ⚠️]"
            case .error: "[ERROR ❌]"
            }
        }
    }

    /// Internal struct to encapsulate the context of the log message
    private struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            "\((file as NSString).lastPathComponent) - \(function) - line \(line)"
        }
    }

    // swiftlint:disable force_unwrapping
    private static let subsystem = Bundle.main.bundleIdentifier!
    // swiftlint:enable force_unwrapping

    static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file, function: function, line: line)
        makeLog(.info, message, context: context)
    }

    static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file, function: function, line: line)
        makeLog(.warning, message, context: context)
    }

    static func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file, function: function, line: line)
        makeLog(.error, message, context: context)
    }

    private static func makeLog(
        _ type: LogType,
        _ message: String,
        context: Context
    ) {
        let logger = Logger(subsystem: subsystem, category: "\(context.description)")
        let logMessage = "\(type.prefix) \n\(message)"
        #if DEBUG
        switch type {
        case .info:
            logger.info("\(logMessage)")
        case .warning:
            logger.warning("\(logMessage)")
        case .error:
            logger.error("\(logMessage)")
        }
        #endif
    }
}
