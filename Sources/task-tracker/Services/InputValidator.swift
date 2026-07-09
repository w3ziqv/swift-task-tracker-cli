import Foundation

/// Service for validating user input
struct InputValidator {
    
    /// Validate task title
    /// - Parameter title: The title to validate
    /// - Returns: True if valid, false otherwise
    static func validateTitle(_ title: String) -> Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count <= 200
    }
    
    /// Validate task number input
    /// - Parameters:
    ///   - input: The user input string
    ///   - maxValue: The maximum valid task number
    /// - Returns: The validated task number (1-indexed) or nil if invalid
    static func validateTaskNumber(_ input: String, maxValue: Int) -> Int? {
        guard let number = Int(input) else { return nil }
        return number >= 1 && number <= maxValue ? number : nil
    }
    
    /// Parse and validate a date string in YYYY-MM-DD format
    /// - Parameter dateString: The date string to parse
    /// - Returns: Date object if valid, nil otherwise
    static func parseDate(_ dateString: String) -> Date? {
        let trimmed = dateString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter.date(from: trimmed)
    }
    
    /// Validate priority string
    /// - Parameter priorityString: The priority string to validate
    /// - Returns: Priority enum value if valid, nil otherwise
    static func validatePriority(_ priorityString: String) -> Priority? {
        return Priority.fromString(priorityString)
    }
    
    /// Validate menu choice
    /// - Parameters:
    ///   - input: The user input
    ///   - validChoices: Array of valid choice strings
    /// - Returns: True if input is a valid choice
    static func validateMenuChoice(_ input: String, validChoices: [String]) -> Bool {
        return validChoices.contains(input)
    }
}
