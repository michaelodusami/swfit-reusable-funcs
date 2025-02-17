//
//  AppConfigManager.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

/// A singleton that manages global settings, API keys, and user preferences.
public class AppConfigManager {
    public static let shared = AppConfigManager()
    
    private init() {
        loadConfigurations()
    }
    
    private var configurations: [String: Any] = [:]
    
    /// Loads configuration values from a plist or other data source.
    private func loadConfigurations() {
        if let path = Bundle.main.path(forResource: "AppConfig", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            configurations = dict
        }
    }
    
    /// Retrieves a configuration value for the given key.
    public func value(forKey key: String) -> Any? {
        return configurations[key]
    }
    
    /// Sets a configuration value for the given key.
    public func setValue(_ value: Any, forKey key: String) {
        configurations[key] = value
        // Optionally, persist the change (e.g., using UserDefaults)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// Retrieves a string configuration value.
    public func string(forKey key: String) -> String? {
        return configurations[key] as? String ?? UserDefaults.standard.string(forKey: key)
    }
    
    /// Retrieves a boolean configuration value.
    public func bool(forKey key: String) -> Bool {
        if let boolValue = configurations[key] as? Bool {
            return boolValue
        }
        return UserDefaults.standard.bool(forKey: key)
    }
    
    /// Example: API key stored in configuration.
    public var apiKey: String? {
        return string(forKey: "APIKey")
    }
    
    /// Example: User preference for theme.
    public var userPreferredTheme: String {
        return string(forKey: "UserPreferredTheme") ?? "Light"
    }
}
