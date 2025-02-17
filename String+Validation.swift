//
//  String+Validation.swift
//  YourProject
//

//

import Foundation
import UIKit

public extension String {
    /// Validates if the string is a valid email address.
    func isValidEmail() -> Bool {
        let emailRegEx = "(?:[A-Z0-9a-z._%+-]+)@(?:[A-Z0-9a-z.-]+)\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    
    /// Validates if the string is a valid phone number (allows optional '+' sign, spaces, and dashes).
    func isValidPhoneNumber() -> Bool {
        let phoneRegEx = "^(\\+)?[0-9\\-\\s]{7,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return predicate.evaluate(with: self)
    }
    
    /// Validates if the string is a valid URL.
    func isValidURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    /// Returns a URL if the string is a valid URL; otherwise, returns nil.
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    /// Checks if the string contains only numeric characters.
    func isNumeric() -> Bool {
        let numberRegEx = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return predicate.evaluate(with: self)
    }
    
    /// Checks if the string contains only alphabetic characters.
    func isAlphabetic() -> Bool {
        let alphaRegEx = "^[A-Za-z]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphaRegEx)
        return predicate.evaluate(with: self)
    }
}
