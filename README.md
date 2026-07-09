# Swift Task Tracker CLI

A feature-rich task tracker written in Swift as a beginner-to-intermediate project for learning programming fundamentals and working with terminal applications.

## Features

### Core Functionality
- ✅ Show all tasks with detailed information
- ✅ Add a new task with title, priority, and due date
- ✅ Mark a task as completed
- ✅ Remove a task
- ✅ Interactive terminal menu

### New Features
- ✅ **Task Persistence** - Tasks are automatically saved to a JSON file and loaded on startup
- ✅ **Task Priorities** - Assign Low, Medium, or High priority to tasks with color-coded display
- ✅ **Due Dates** - Set optional due dates for tasks
- ✅ **Creation Dates** - Track when each task was created
- ✅ **Bilingual Support** - Toggle between Polish and English languages
- ✅ **Colorful Output** - ANSI color codes for better terminal readability
- ✅ **Input Validation** - Comprehensive validation for all user inputs
- ✅ **Error Handling** - Graceful error handling with user-friendly messages

## Tech Stack

- **Swift 6.3+**
- **Swift Package Manager**
- **Foundation Framework** (for JSON encoding/decoding, Date handling)
- **Swift Testing Framework**

## Project Structure

```
Sources/task-tracker/
├── Models/
│   ├── Task.swift          # Task model with priority and dates
│   └── Language.swift      # Language support and localization
├── Services/
│   ├── TaskStorage.swift   # JSON file persistence
│   └── InputValidator.swift # Input validation utilities
├── UI/
│   └── ConsoleOutput.swift # Colorful terminal output
└── main.swift             # Main application entry point

Tests/task-trackerTests/
├── TaskTests.swift         # Comprehensive unit tests
└── task_trackerTests.swift # Test file aggregator
```

## Getting Started

### Prerequisites
- Swift 6.3 or later
- macOS 13+ (Ventura) or Linux

### Installation

1. Clone the repository:
```bash
git clone https://github.com/w3ziqv/swift-task-tracker-cli.git
cd swift-task-tracker-cli
```

2. Build and run:
```bash
swift run
```

3. Run tests:
```bash
swift test
```

## Usage

### Menu Options

| Option | Polish | English | Description |
|--------|--------|---------|-------------|
| 1 | Pokaż zadania | Show tasks | Display all tasks with status, priority, and due dates |
| 2 | Dodaj zadanie | Add task | Add a new task with title, priority, and optional due date |
| 3 | Oznacz jako zrobione | Mark as completed | Mark an existing task as completed |
| 4 | Usuń zadanie | Remove task | Remove a task from the list |
| 5 | Zmień język | Change language | Toggle between Polish and English |
| 6 | Wyjście | Exit | Exit the application |

### Adding a Task

When adding a task, you'll be prompted for:
1. **Title** (required) - The task description
2. **Priority** (optional, default: Medium) - Choose from: 🟢 Low, 🟡 Medium, 🔴 High
3. **Due Date** (optional) - Format: YYYY-MM-DD

### Priority Levels

- **🟢 Low** - Low priority tasks (green)
- **🟡 Medium** - Medium priority tasks (yellow)
- **🔴 High** - High priority tasks (red)

### Task Display

Tasks are displayed with:
- Number (for selection)
- Status: [ ] for pending, [✓] for completed
- Priority indicator with color
- Title
- Due date (if set)

Completed tasks are shown with dimmed text.

## Examples

### Polish Menu
```text
=== ZARZĄDZANIE ZADANIAMI ===

  1. Pokaż zadania
  2. Dodaj zadanie
  3. Oznacz jako zrobione
  4. Usuń zadanie
  5. Zmień język
  6. Wyjście

Aktualny język: Polski
Wybierz opcję:
```

### English Menu
```text
=== TASK TRACKER ===

  1. Show tasks
  2. Add task
  3. Mark as completed
  4. Remove task
  5. Change language
  6. Exit

Current language: English
Choose an option:
```

### Task List Example
```text
  1. [ ] [🔴 High] Buy groceries - Due: 12/25/24
  2. [✓] [🟡 Medium] Finish project
  3. [ ] [🟢 Low] Call mom
```

## Testing

The project includes comprehensive unit tests for:
- Task model and priority enum
- Input validation
- Language support and localization
- Task storage (save/load)
- JSON encoding/decoding

Run tests with:
```bash
swift test
```

## Code Quality

This project demonstrates:
- ✅ **Modular Architecture** - Separated into Models, Services, and UI layers
- ✅ **Type Safety** - Strong typing with enums and optionals
- ✅ **Error Handling** - Graceful error recovery
- ✅ **Input Validation** - Comprehensive validation for all user inputs
- ✅ **Internationalization** - Support for multiple languages
- ✅ **Persistence** - JSON file storage
- ✅ **Testing** - Comprehensive unit tests
- ✅ **Documentation** - Code comments and docstrings
- ✅ **Clean Code** - Follows Swift API Design Guidelines

## Future Improvements

Potential enhancements:
- Add task categories or tags
- Implement task search/filter functionality
- Add sorting options (by date, priority, etc.)
- Support for recurring tasks
- Export tasks to different formats (CSV, etc.)
- Add more languages
- Implement a proper command-line argument parser
- Add keyboard shortcuts
- Support for dark/light terminal themes

## Why I Built This

This project was created as part of learning Swift from scratch and evolving it into a more sophisticated application. It helped me practice:

- **Swift Fundamentals**: functions, loops, conditionals, structs, classes, enums
- **Collections**: arrays, dictionaries
- **Error Handling**: do-try-catch, optional binding
- **File I/O**: Reading and writing JSON files
- **Date Handling**: Date, DateFormatter, Calendar
- **Codable Protocol**: JSON encoding and decoding
- **Modular Design**: Organizing code into separate files and modules
- **Testing**: Writing unit tests with Swift Testing framework
- **User Input**: Handling terminal input with validation
- **Internationalization**: Supporting multiple languages
- **Terminal Output**: Using ANSI color codes for better UX

## License

MIT License - Feel free to use, modify, and distribute this code.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
