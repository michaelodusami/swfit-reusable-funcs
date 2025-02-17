//
//  Date+Formatters.swift
//  YourProject
//
//  Created by YourName on Date.
//

import Foundation

public extension Date {
    /// Returns a string representation of the date using the specified format.
    func formatted(as format: String, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self)
    }
    
    /// Returns a relative time string (e.g., "30 seconds ago", "5 minutes ago").
    func timeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 3600
        let day = 86400
        let week = 604800
        
        if secondsAgo < minute {
            return "\(secondsAgo) second\(secondsAgo != 1 ? "s" : "") ago"
        } else if secondsAgo < hour {
            let minutes = secondsAgo / minute
            return "\(minutes) minute\(minutes != 1 ? "s" : "") ago"
        } else if secondsAgo < day {
            let hours = secondsAgo / hour
            return "\(hours) hour\(hours != 1 ? "s" : "") ago"
        } else if secondsAgo < week {
            let days = secondsAgo / day
            return "\(days) day\(days != 1 ? "s" : "") ago"
        } else {
            let weeks = secondsAgo / week
            return "\(weeks) week\(weeks != 1 ? "s" : "") ago"
        }
    }
    
    /// Returns a new Date by adding a given number of days.
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// Returns a new Date by adding a given number of hours.
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }
    
    /// Returns a new Date by adding a given number of minutes.
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
    
    /// Returns the number of days between the current date and another date.
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    /// Creates a Date from a string using the specified format.
    static func from(string: String, format: String, locale: Locale = .current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.date(from: string)
    }
    
    /// Returns the start of the day for the date.
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Returns the end of the day for the date.
    func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay()) ?? self
    }
}
