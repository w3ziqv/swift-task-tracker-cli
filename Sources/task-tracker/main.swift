import Foundation

/// Main application class
class TaskTrackerApp {
    private var tasks: [Task] = []
    private let storage: TaskStorage
    private var isRunning: Bool = true
    
    init(storage: TaskStorage = TaskStorage()) {
        self.storage = storage
        loadTasks()
    }
    
    /// Load tasks from storage
    private func loadTasks() {
        tasks = storage.load()
    }
    
    /// Save tasks to storage
    private func saveTasks() {
        do {
            try storage.save(tasks: tasks)
        } catch {
            ConsoleOutput.printError("Error saving tasks: \(error.localizedDescription)")
        }
    }
    
    /// Display the main menu
    private func showMenu() {
        ConsoleOutput.printHeader(LocalizedStrings.get("app_title"))
        ConsoleOutput.printLanguageIndicator()
        ConsoleOutput.printMenuOption("1", LocalizedStrings.get("menu_show_tasks"))
        ConsoleOutput.printMenuOption("2", LocalizedStrings.get("menu_add_task"))
        ConsoleOutput.printMenuOption("3", LocalizedStrings.get("menu_complete_task"))
        ConsoleOutput.printMenuOption("4", LocalizedStrings.get("menu_remove_task"))
        ConsoleOutput.printMenuOption("5", LocalizedStrings.get("menu_change_language"))
        ConsoleOutput.printMenuOption("6", LocalizedStrings.get("menu_exit"))
        print("")
        print(LocalizedStrings.get("menu_choose"))
    }
    
    /// Display all tasks
    private func showTasks() {
        ConsoleOutput.printHeader(LocalizedStrings.get("menu_show_tasks"))
        
        if tasks.isEmpty {
            ConsoleOutput.printWarning(LocalizedStrings.get("no_tasks"))
            return
        }
        
        for (index, task) in tasks.enumerated() {
            ConsoleOutput.printTask(task, index: index + 1)
        }
        
        ConsoleOutput.printSeparator()
    }
    
    /// Add a new task
    private func addTask() {
        ConsoleOutput.printHeader(LocalizedStrings.get("menu_add_task"))
        
        print(LocalizedStrings.get("enter_task_title"))
        guard let title = readLine(), InputValidator.validateTitle(title) else {
            ConsoleOutput.printError(LocalizedStrings.get("empty_title_error"))
            return
        }
        
        print(LocalizedStrings.get("enter_task_priority"))
        guard let priorityInput = readLine(), 
              let priority = InputValidator.validatePriority(priorityInput) else {
            ConsoleOutput.printError(LocalizedStrings.get("invalid_priority_error"))
            return
        }
        
        print(LocalizedStrings.get("enter_due_date"))
        let dueDate: Date?
        if let dateInput = readLine(), !dateInput.isEmpty {
            dueDate = InputValidator.parseDate(dateInput)
            if dueDate == nil {
                ConsoleOutput.printError(LocalizedStrings.get("invalid_date_format"))
                return
            }
        } else {
            dueDate = nil
        }
        
        let task = Task(title: title, priority: priority, dueDate: dueDate)
        tasks.append(task)
        saveTasks()
        ConsoleOutput.printSuccess(LocalizedStrings.get("task_added"))
    }
    
    /// Mark a task as completed
    private func completeTask() {
        ConsoleOutput.printHeader(LocalizedStrings.get("menu_complete_task"))
        
        if tasks.isEmpty {
            ConsoleOutput.printWarning(LocalizedStrings.get("no_tasks"))
            return
        }
        
        showTasks()
        print(LocalizedStrings.get("enter_task_number"))
        
        guard let input = readLine(), 
              let taskNumber = InputValidator.validateTaskNumber(input, maxValue: tasks.count) else {
            ConsoleOutput.printError(LocalizedStrings.get("invalid_number"))
            return
        }
        
        tasks[taskNumber - 1].isDone = true
        saveTasks()
        ConsoleOutput.printSuccess(LocalizedStrings.get("task_completed"))
    }
    
    /// Remove a task
    private func removeTask() {
        ConsoleOutput.printHeader(LocalizedStrings.get("menu_remove_task"))
        
        if tasks.isEmpty {
            ConsoleOutput.printWarning(LocalizedStrings.get("no_tasks"))
            return
        }
        
        showTasks()
        print(LocalizedStrings.get("enter_task_number"))
        
        guard let input = readLine(), 
              let taskNumber = InputValidator.validateTaskNumber(input, maxValue: tasks.count) else {
            ConsoleOutput.printError(LocalizedStrings.get("invalid_number"))
            return
        }
        
        tasks.remove(at: taskNumber - 1)
        saveTasks()
        ConsoleOutput.printSuccess(LocalizedStrings.get("task_removed"))
    }
    
    /// Change application language
    private func changeLanguage() {
        Language.toggle()
        let langName = Language.current == .polish ? "Polski" : "English"
        let message = String(format: LocalizedStrings.get("language_changed"), langName)
        ConsoleOutput.printSuccess(message)
    }
    
    /// Handle menu selection
    private func handleMenuChoice(_ choice: String) {
        switch choice {
        case "1":
            showTasks()
        case "2":
            addTask()
        case "3":
            completeTask()
        case "4":
            removeTask()
        case "5":
            changeLanguage()
        case "6":
            isRunning = false
            ConsoleOutput.printSuccess(LocalizedStrings.get("goodbye"))
        default:
            ConsoleOutput.printError(LocalizedStrings.get("unknown_option"))
        }
    }
    
    /// Run the main application loop
    func run() {
        while isRunning {
            showMenu()
            
            if let choice = readLine() {
                handleMenuChoice(choice)
            }
        }
    }
}

// Entry point
let app = TaskTrackerApp()
app.run()
