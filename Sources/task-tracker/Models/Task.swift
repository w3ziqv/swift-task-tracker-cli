import Foundation

/// Represents a task with title, completion status, priority, and dates
enum Priority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var displayValue: String {
        switch self {
        case .low: return "🟢 Low"
        case .medium: return "🟡 Medium"
        case .high: return "🔴 High"
        }
    }
    
    static func fromString(_ string: String) -> Priority? {
        switch string.lowercased() {
        case "low", "niski", "niskie": return .low
        case "medium", "średni", "średnia": return .medium
        case "high", "wysoki", "wysoka": return .high
        default: return nil
        }
    }
    
    static var allCasesDisplay: String {
        allCases.map { $0.displayValue }.joined(separator: ", ")
    }
}

struct Task: Codable {
    var title: String
    var isDone: Bool
    var priority: Priority
    var dueDate: Date?
    var createdDate: Date
    
    init(title: String, isDone: Bool = false, priority: Priority = .medium, dueDate: Date? = nil) {
        self.title = title
        self.isDone = isDone
        self.priority = priority
        self.dueDate = dueDate
        self.createdDate = Date()
    }
    
    /// Formatted due date string
    var formattedDueDate: String {
        guard let dueDate = dueDate else { return "No due date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: dueDate)
    }
    
    /// Formatted created date string
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: createdDate)
    }
}
