import Foundation

/// ANSI color codes for terminal output
enum ConsoleColor: String {
    case reset = "\u{001B}[0;0m"
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case bold = "\u{001B}[1m"
    case dim = "\u{001B}[2m"
    case underline = "\u{001B}[4m"
}

/// Service for formatted console output
struct ConsoleOutput {
    private static var useColors: Bool = true
    
    static func setUseColors(_ enabled: Bool) {
        useColors = enabled
    }
    
    private static func colorize(_ text: String, _ color: ConsoleColor) -> String {
        guard useColors else { return text }
        return "\(color.rawValue)\(text)\(ConsoleColor.reset.rawValue)"
    }
    
    /// Print a success message in green
    static func printSuccess(_ message: String) {
        print(colorize(message, .green))
    }
    
    /// Print an error message in red
    static func printError(_ message: String) {
        print(colorize(message, .red))
    }
    
    /// Print a warning message in yellow
    static func printWarning(_ message: String) {
        print(colorize(message, .yellow))
    }
    
    /// Print an info message in blue
    static func printInfo(_ message: String) {
        print(colorize(message, .blue))
    }
    
    /// Print a header in cyan with bold
    static func printHeader(_ message: String) {
        print(colorize("\n" + message + "\n", .cyan))
    }
    
    /// Print a separator line
    static func printSeparator() {
        print(colorize(String(repeating: "-", count: 40), .dim))
    }
    
    /// Print a task with appropriate formatting
    static func printTask(_ task: Task, index: Int) {
        let statusSymbol = task.isDone ? "[✓]" : "[ ]"
        let statusColor: ConsoleColor = task.isDone ? .green : .white
        let priorityColor: ConsoleColor = 
            task.priority == .high ? .red : 
            task.priority == .medium ? .yellow : .green
        
        let statusText = colorize(statusSymbol, statusColor)
        let priorityText = colorize("[\(task.priority.displayValue)]", priorityColor)
        let titleText = task.isDone ? colorize(task.title, .dim) : task.title
        
        let dueDateText = task.dueDate != nil ? " - Due: \(task.formattedDueDate)" : ""
        
        print("  \(index). \(statusText) \(priorityText) \(titleText)\(dueDateText)")
    }
    
    /// Print task details
    static func printTaskDetails(_ task: Task) {
        printHeader(LocalizedStrings.get("task_details"))
        print("  \(LocalizedStrings.get("title")): \(task.title)")
        print("  \(LocalizedStrings.get("status")): \(task.isDone ? LocalizedStrings.get("completed") : LocalizedStrings.get("pending"))")
        print("  \(LocalizedStrings.get("priority")): \(task.priority.displayValue)")
        print("  \(LocalizedStrings.get("created")): \(task.formattedCreatedDate)")
        print("  \(LocalizedStrings.get("due")): \(task.formattedDueDate)")
        printSeparator()
    }
    
    /// Print a numbered menu option
    static func printMenuOption(_ number: String, _ text: String) {
        print("  \(colorize(number, .yellow)). \(text)")
    }
    
    /// Print the current language indicator
    static func printLanguageIndicator() {
        let langText = String(format: LocalizedStrings.get("current_language"), 
                              Language.current == .polish ? "Polski" : "English")
        printInfo(langText)
    }
}
