import Foundation

public struct DisplayUtils {
    
    // MARK: - Text Functions
    
    /// Returns the string trimmed of whitespace and newlines.
    public static func trimmed(_ text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Capitalizes the first letter of the given string.
    public static func capitalizeFirstLetter(_ text: String) -> String {
        guard let first = text.first else { return text }
        return first.uppercased() + text.dropFirst()
    }
    
    /// Checks if the given string is a valid email address using a regular expression.
    public static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+)*|\"(?:[\\u{21}\\u{23}-\\u{5B}\\u{5D}-\\u{7E}]|\\\\[\\u{21}-\\u{7E}])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?:\\.(?!$)|$)){4}\\])"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    /// Removes HTML tags from a string.
    public static func stripHTML(from text: String) -> String {
        guard let data = text.data(using: .utf8) else { return text }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        }
        return text
    }
    
    /// Extracts the initials from a full name.
    public static func initials(from name: String) -> String {
        let components = name.components(separatedBy: .whitespaces)
        let initials = components.compactMap { $0.first?.uppercased() }
        return initials.joined()
    }
    
    /// Generates a random alphanumeric string of the specified length.
    public static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in letters.randomElement() })
    }
    
    
    // MARK: - Number Functions
    
    /// Abbreviates a number to a shorter format (e.g., 1.2K, 3.4M, 5.6B).
    public static func abbreviateNumber(_ num: Double) -> String {
        let absNum = abs(num)
        let sign = (num < 0) ? "-" : ""
        switch absNum {
        case 1_000_000_000...:
            return "\(sign)\(formatDecimal(absNum / 1_000_000_000, decimals: 1))B"
        case 1_000_000...:
            return "\(sign)\(formatDecimal(absNum / 1_000_000, decimals: 1))M"
        case 1_000...:
            return "\(sign)\(formatDecimal(absNum / 1_000, decimals: 1))K"
        default:
            return "\(sign)\(formatDecimal(absNum, decimals: 0))"
        }
    }
    
    /// Formats a number as a currency string using the provided locale.
    public static func formatCurrency(_ value: Double, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    /// Formats a number to a string with a specified number of decimal places.
    public static func formatDecimal(_ value: Double, decimals: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    /// Rounds a value to the specified number of decimal places.
    public static func round(_ value: Double, to places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return Darwin.round(value * multiplier) / multiplier
    }
    
    /// Converts a decimal value to a percentage string.
    public static func percentageString(from value: Double, decimals: Int = 1) -> String {
        return "\(formatDecimal(value * 100, decimals: decimals))%"
    }
    
    /// Calculates the percentage change from an old value to a new value.
    public static func percentChange(from old: Double, to new: Double) -> Double {
        guard old != 0 else { return 0 }
        return ((new - old) / abs(old)) * 100
    }
    
    /// Formats a distance (in meters) into a user-friendly string, switching to kilometers or miles as needed.
    public static func formattedDistance(_ distance: Double, inMeters: Bool = true) -> String {
        if inMeters {
            if distance < 1000 {
                return "\(Int(distance)) m"
            } else {
                let km = distance / 1000
                return "\(formatDecimal(km, decimals: 1)) km"
            }
        } else {
            // Convert to miles (1 mile = 1609.34 meters)
            let miles = distance / 1609.34
            return "\(formatDecimal(miles, decimals: 1)) mi"
        }
    }
    
    
    // MARK: - Date Functions
    
    /// Formats a Date into a string using the specified format and locale.
    public static func formatDate(_ date: Date, format: String = "yyyy-MM-dd HH:mm:ss", locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: date)
    }
    
    /// Converts a string to a Date using the specified format and locale.
    public static func dateFromString(_ dateString: String, format: String = "yyyy-MM-dd HH:mm:ss", locale: Locale = .current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.date(from: dateString)
    }
    
    /// Returns a relative date string (e.g., "just now", "2 minutes ago", "3 days ago").
    public static func relativeDateString(from date: Date) -> String {
        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(date))
        
        if secondsAgo < 60 {
            return "just now"
        } else if secondsAgo < 3600 {
            let minutes = secondsAgo / 60
            return "\(minutes) minute\(minutes > 1 ? "s" : "") ago"
        } else if secondsAgo < 86400 {
            let hours = secondsAgo / 3600
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"
        } else if secondsAgo < 604800 {
            let days = secondsAgo / 86400
            return "\(days) day\(days > 1 ? "s" : "") ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    /// Returns the number of days between two dates.
    public static func daysBetween(_ start: Date, _ end: Date) -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: start)
        let endOfDay = calendar.startOfDay(for: end)
        let components = calendar.dateComponents([.day], from: startOfDay, to: endOfDay)
        return components.day ?? 0
    }
    
    /// Returns the number of weeks between two dates.
    public static func weeksBetween(_ start: Date, _ end: Date) -> Int {
        return daysBetween(start, end) / 7
    }
    
    /// Checks if a given date is in the past.
    public static func isDateInPast(_ date: Date) -> Bool {
        return date < Date()
    }
    
    
    // MARK: - Miscellaneous Functions
    
    /// Returns the ordinal string representation for an integer (e.g., 1st, 2nd, 3rd).
    public static func ordinalString(from number: Int) -> String {
        var suffix = "th"
        let ones = number % 10
        let tens = (number / 10) % 10
        if tens != 1 {
            switch ones {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: break
            }
        }
        return "\(number)\(suffix)"
    }
}
