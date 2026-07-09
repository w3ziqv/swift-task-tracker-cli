import Testing
@testable import task_tracker

// MARK: - Task Model Tests

@Test func testTaskInitialization() {
    let task = Task(title: "Test Task")
    #expect(task.title == "Test Task")
    #expect(task.isDone == false)
    #expect(task.priority == .medium)
    #expect(task.dueDate == nil)
}

@Test func testTaskWithAllParameters() {
    let dueDate = Date()
    let task = Task(title: "Test", isDone: true, priority: .high, dueDate: dueDate)
    #expect(task.title == "Test")
    #expect(task.isDone == true)
    #expect(task.priority == .high)
    #expect(task.dueDate != nil)
}

@Test func testTaskFormattedDueDate() {
    let calendar = Calendar.current
    let components = DateComponents(year: 2024, month: 12, day: 25)
    let dueDate = calendar.date(from: components)!
    
    let task = Task(title: "Test", dueDate: dueDate)
    let formattedDate = task.formattedDueDate
    
    #expect(formattedDate.contains("25"))
    #expect(formattedDate.contains("12"))
    #expect(formattedDate.contains("2024"))
}

@Test func testTaskNoDueDate() {
    let task = Task(title: "Test")
    #expect(task.formattedDueDate == "No due date")
}

// MARK: - Priority Tests

@Test func testPriorityDisplayValues() {
    #expect(Priority.low.displayValue == "🟢 Low")
    #expect(Priority.medium.displayValue == "🟡 Medium")
    #expect(Priority.high.displayValue == "🔴 High")
}

@Test func testPriorityFromString() {
    #expect(Priority.fromString("low") == .low)
    #expect(Priority.fromString("LOW") == .low)
    #expect(Priority.fromString("niski") == .low)
    #expect(Priority.fromString("medium") == .medium)
    #expect(Priority.fromString("MEDIUM") == .medium)
    #expect(Priority.fromString("średni") == .medium)
    #expect(Priority.fromString("high") == .high)
    #expect(Priority.fromString("HIGH") == .high)
    #expect(Priority.fromString("wysoki") == .high)
    #expect(Priority.fromString("invalid") == nil)
}

@Test func testPriorityAllCasesDisplay() {
    let display = Priority.allCasesDisplay
    #expect(display.contains("🟢 Low"))
    #expect(display.contains("🟡 Medium"))
    #expect(display.contains("🔴 High"))
}

// MARK: - InputValidator Tests

@Test func testValidateTitle() {
    #expect(InputValidator.validateTitle("Valid Task") == true)
    #expect(InputValidator.validateTitle("   Valid   ") == true)
    #expect(InputValidator.validateTitle("") == false)
    #expect(InputValidator.validateTitle("   ") == false)
    #expect(InputValidator.validateTitle(String(repeating: "a", count: 201)) == false)
}

@Test func testValidateTaskNumber() {
    #expect(InputValidator.validateTaskNumber("1", maxValue: 5) == 1)
    #expect(InputValidator.validateTaskNumber("5", maxValue: 5) == 5)
    #expect(InputValidator.validateTaskNumber("0", maxValue: 5) == nil)
    #expect(InputValidator.validateTaskNumber("6", maxValue: 5) == nil)
    #expect(InputValidator.validateTaskNumber("abc", maxValue: 5) == nil)
    #expect(InputValidator.validateTaskNumber("", maxValue: 5) == nil)
}

@Test func testParseDate() {
    let date = InputValidator.parseDate("2024-12-25")
    #expect(date != nil)
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date!)
    #expect(components.year == 2024)
    #expect(components.month == 12)
    #expect(components.day == 25)
}

@Test func testParseInvalidDate() {
    #expect(InputValidator.parseDate("invalid") == nil)
    #expect(InputValidator.parseDate("25-12-2024") == nil)
    #expect(InputValidator.parseDate("") == nil)
}

@Test func testValidatePriority() {
    #expect(InputValidator.validatePriority("low") == .low)
    #expect(InputValidator.validatePriority("medium") == .medium)
    #expect(InputValidator.validatePriority("high") == .high)
    #expect(InputValidator.validatePriority("invalid") == nil)
}

// MARK: - Language Tests

@Test func testLanguageToggle() {
    let initial = Language.current
    Language.toggle()
    let toggled = Language.current
    Language.toggle()
    #expect(Language.current == initial)
}

@Test func testSetLanguage() {
    Language.setLanguage("en")
    #expect(Language.current == .english)
    
    Language.setLanguage("pl")
    #expect(Language.current == .polish)
    
    Language.setLanguage("invalid")
    #expect(Language.current == .polish)
}

// MARK: - LocalizedStrings Tests

@Test func testLocalizedStringsPolish() {
    Language.setLanguage("pl")
    #expect(LocalizedStrings.get("app_title") == "=== ZARZĄDZANIE ZADANIAMI ===")
    #expect(LocalizedStrings.get("menu_show_tasks") == "1. Pokaż zadania")
    #expect(LocalizedStrings.get("goodbye") == "Koniec programu.")
}

@Test func testLocalizedStringsEnglish() {
    Language.setLanguage("en")
    #expect(LocalizedStrings.get("app_title") == "=== TASK TRACKER ===")
    #expect(LocalizedStrings.get("menu_show_tasks") == "1. Show tasks")
    #expect(LocalizedStrings.get("goodbye") == "Goodbye.")
}

// MARK: - TaskStorage Tests

@Test func testTaskStorageSaveAndLoad() {
    // Create a temporary storage for testing
    let tempFileName = "test_tasks_\(UUID().uuidString).json"
    let storage = TaskStorage(fileName: tempFileName)
    
    let testTasks = [
        Task(title: "Task 1", priority: .low),
        Task(title: "Task 2", priority: .high, dueDate: Date())
    ]
    
    // Save tasks
    try? storage.save(tasks: testTasks)
    
    // Load tasks
    let loadedTasks = storage.load()
    
    #expect(loadedTasks.count == 2)
    #expect(loadedTasks[0].title == "Task 1")
    #expect(loadedTasks[0].priority == .low)
    #expect(loadedTasks[1].title == "Task 2")
    #expect(loadedTasks[1].priority == .high)
    
    // Cleanup
    try? storage.deleteFile()
}

@Test func testTaskStorageLoadEmpty() {
    let tempFileName = "nonexistent_\(UUID().uuidString).json"
    let storage = TaskStorage(fileName: tempFileName)
    
    let loadedTasks = storage.load()
    #expect(loadedTasks.isEmpty)
}

// MARK: - Task Codable Tests

@Test func testTaskEncodingDecoding() {
    let originalTask = Task(title: "Test", isDone: true, priority: .high, dueDate: Date())
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    
    let data = try? encoder.encode(originalTask)
    #expect(data != nil)
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let decodedTask = try? decoder.decode(Task.self, from: data!)
    #expect(decodedTask != nil)
    #expect(decodedTask?.title == originalTask.title)
    #expect(decodedTask?.isDone == originalTask.isDone)
    #expect(decodedTask?.priority == originalTask.priority)
}
