import Foundation

/// Supported languages for the application
enum Language: String, CaseIterable {
    case polish = "pl"
    case english = "en"
    
    static var current: Language = .polish
    
    static func setLanguage(_ code: String) {
        if code.lowercased() == "en" {
            current = .english
        } else {
            current = .polish
        }
    }
    
    static func toggle() {
        current = current == .polish ? .english : .polish
    }
}

/// Localized strings for the application
struct LocalizedStrings {
    static func get(_ key: String) -> String {
        let translations: [Language: [String: String]] = [
            .polish: [
                "app_title": "=== ZARZĄDZANIE ZADANIAMI ===",
                "menu_show_tasks": "1. Pokaż zadania",
                "menu_add_task": "2. Dodaj zadanie",
                "menu_complete_task": "3. Oznacz jako zrobione",
                "menu_remove_task": "4. Usuń zadanie",
                "menu_change_language": "5. Zmień język",
                "menu_exit": "6. Wyjście",
                "menu_choose": "Wybierz opcję:",
                "no_tasks": "Brak zadań.",
                "enter_task_title": "Podaj nazwę zadania:",
                "enter_task_priority": "Podaj priorytet (" + Priority.allCasesDisplay + "):",
                "enter_due_date": "Podaj datę zakończenia (YYYY-MM-DD, opcjonalnie):",
                "task_added": "Dodano zadanie.",
                "empty_title_error": "Nazwa zadania nie może być pusta.",
                "invalid_priority_error": "Nieprawidłowy priorytet. Dostępne: " + Priority.allCasesDisplay,
                "enter_task_number": "Podaj numer zadania:",
                "task_completed": "Zadanie oznaczone jako zrobione.",
                "task_removed": "Zadanie usunięte.",
                "invalid_number": "Nieprawidłowy numer.",
                "enter_valid_number": "Wpisz poprawną liczbę.",
                "unknown_option": "Nieznana opcja.",
                "goodbye": "Koniec programu.",
                "language_changed": "Język zmieniony na: %@",
                "current_language": "Aktualny język: %@",
                "invalid_date_format": "Nieprawidłowy format daty. Użyj YYYY-MM-DD.",
                "task_details": "Szczegóły zadania",
                "title": "Tytuł",
                "status": "Status",
                "priority": "Priorytet",
                "created": "Utworzono",
                "due": "Termin",
                "completed": "Zakończone",
                "pending": "W toku",
                "back": "Powrót"
            ],
            .english: [
                "app_title": "=== TASK TRACKER ===",
                "menu_show_tasks": "1. Show tasks",
                "menu_add_task": "2. Add task",
                "menu_complete_task": "3. Mark as completed",
                "menu_remove_task": "4. Remove task",
                "menu_change_language": "5. Change language",
                "menu_exit": "6. Exit",
                "menu_choose": "Choose an option:",
                "no_tasks": "No tasks.",
                "enter_task_title": "Enter task title:",
                "enter_task_priority": "Enter priority (" + Priority.allCasesDisplay + "):",
                "enter_due_date": "Enter due date (YYYY-MM-DD, optional):",
                "task_added": "Task added.",
                "empty_title_error": "Task title cannot be empty.",
                "invalid_priority_error": "Invalid priority. Available: " + Priority.allCasesDisplay,
                "enter_task_number": "Enter task number:",
                "task_completed": "Task marked as completed.",
                "task_removed": "Task removed.",
                "invalid_number": "Invalid number.",
                "enter_valid_number": "Please enter a valid number.",
                "unknown_option": "Unknown option.",
                "goodbye": "Goodbye.",
                "language_changed": "Language changed to: %@",
                "current_language": "Current language: %@",
                "invalid_date_format": "Invalid date format. Use YYYY-MM-DD.",
                "task_details": "Task Details",
                "title": "Title",
                "status": "Status",
                "priority": "Priority",
                "created": "Created",
                "due": "Due",
                "completed": "Completed",
                "pending": "Pending",
                "back": "Back"
            ]
        ]
        
        return translations[Language.current]?[key] ?? key
    }
}
