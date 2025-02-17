//
//  Log.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

/// Log levels for the custom logger.
public enum LogLevel: Int, CustomStringConvertible {
    case debug = 0, info, warning, error
    
    public var description: String {
        switch self {
        case .debug:   return "DEBUG"
        case .info:    return "INFO"
        case .warning: return "WARNING"
        case .error:   return "ERROR"
        }
    }
}

/// A custom logging system for debugging and analytics.
public class Log {
    public static var isEnabled: Bool = true
    
    /// Logs a message with the given level and contextual information.
    public static func message(_ message: String,
                               level: LogLevel = .debug,
                               file: String = #file,
                               function: String = #function,
                               line: Int = #line) {
        guard isEnabled else { return }
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(level)] \(fileName):\(line) \(function) -> \(message)"
        print(logMessage)
        // Optionally, forward the log to an analytics server or file.
    }
    
    /// Convenience function for debug-level logging.
    public static func debug(_ message: String,
                             file: String = #file,
                             function: String = #function,
                             line: Int = #line) {
        message(message, level: .debug, file: file, function: function, line: line)
    }
    
    /// Convenience function for info-level logging.
    public static func info(_ message: String,
                            file: String = #file,
                            function: String = #function,
                            line: Int = #line) {
        message(message, level: .info, file: file, function: function, line: line)
    }
    
    /// Convenience function for warning-level logging.
    public static func warning(_ message: String,
                               file: String = #file,
                               function: String = #function,
                               line: Int = #line) {
        message(message, level: .warning, file: file, function: function, line: line)
    }
    
    /// Convenience function for error-level logging.
    public static func error(_ message: String,
                             file: String = #file,
                             function: String = #function,
                             line: Int = #line) {
        message(message, level: .error, file: file, function: function, line: line)
    }
}
