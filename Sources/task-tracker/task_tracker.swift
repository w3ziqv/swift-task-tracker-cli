import Foundation

// ANSI color codes for nicer terminal output
let RESET = "\u{001B}[0m"
let GREEN = "\u{001B}[32m"
let RED = "\u{001B}[31m"
let YELLOW = "\u{001B}[33m"

struct Task: Codable {
    var title: String
    var isDone: Bool
    var priority: Int // 1 = high, 2 = medium (default), 3 = low
}

func priorityLabel(_ priority: Int) -> String {
    switch priority {
    case 1: return "[H]"
    case 2: return "[M]"
    case 3: return "[L]"
    default: return "[M]"
    }
}

func priorityColor(_ priority: Int) -> String {
    switch priority {
    case 1: return RED
    case 2: return YELLOW
    default: return RESET
    }
}

func showMenu() {
    print("")
    print("=== TASK TRACKER ===")
    print("1. Pokaż zadania")
    print("2. Dodaj zadanie")
    print("3. Oznacz jako zrobione")
    print("4. Usuń zadanie")
    print("5. Wyjście")
    print("Wybierz opcję:")
}

func showTasks(tasks: [Task]) {
    if tasks.isEmpty {
        print("Brak zadań.")
    } else {
        for i in 0..<tasks.count {
            let status = tasks[i].isDone ? "[x]" : "[ ]"
            let label = priorityLabel(tasks[i].priority)
            let title = tasks[i].title
            let color: String
            if tasks[i].isDone {
                color = GREEN
            } else {
                color = priorityColor(tasks[i].priority)
            }
            print("\(i + 1). \(status) \(label) \(color)\(title)\(RESET)")
        }
    }
}

func addTask(tasks: inout [Task]) {
    print("Podaj nazwę zadania:")

    guard let title = readLine() else {
        print("Nazwa zadania nie może być pusta.")
        return
    }
    let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty {
        print("Nazwa zadania nie może być pusta.")
        return
    }

    print("Priorytet (1 = wysoki, 2 = średni, 3 = niski):")
    var priority = 2
    if let input = readLine(), let number = Int(input), (1...3).contains(number) {
        priority = number
    } else {
        print("Nieprawidłowy priorytet, ustawiam domyślny (średni).")
    }

    let task = Task(title: trimmed, isDone: false, priority: priority)
    tasks.append(task)
    print("Dodano zadanie.")
}

func completeTask(tasks: inout [Task]) {
    showTasks(tasks: tasks)
    
    if tasks.isEmpty {
        return
    }
    
    print("Podaj numer zadania do oznaczenia:")
    
    if let input = readLine(), let number = Int(input) {
        if number >= 1 && number <= tasks.count {
            tasks[number - 1].isDone = true
            print("Zadanie oznaczone jako zrobione.")
        } else {
            print("Nieprawidłowy numer.")
        }
    } else {
        print("Wpisz poprawną liczbę.")
    }
}

func removeTask(tasks: inout [Task]) {
    showTasks(tasks: tasks)
    
    if tasks.isEmpty {
        return
    }
    
    print("Podaj numer zadania do usunięcia:")
    
    if let input = readLine(), let number = Int(input) {
        if number >= 1 && number <= tasks.count {
            tasks.remove(at: number - 1)
            print("Zadanie usunięte.")
        } else {
            print("Nieprawidłowy numer.")
        }
    } else {
        print("Wpisz poprawną liczbę.")
    }
}

func saveTasks(tasks: [Task], to url: URL) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let data = try encoder.encode(tasks)
        try data.write(to: url, options: .atomic)
    } catch {
        print("Błąd zapisu pliku: \(error)")
    }
}

func loadTasks(from url: URL) -> [Task] {
    let decoder = JSONDecoder()
    do {
        let data = try Data(contentsOf: url)
        return try decoder.decode([Task].self, from: data)
    } catch {
        return []
    }
}

func main() {
    let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("tasks.json")

    var tasks: [Task] = loadTasks(from: fileURL)
    var isRunning = true

    while isRunning {
        showMenu()

        if let choice = readLine() {
            switch choice {
            case "1":
                showTasks(tasks: tasks)
            case "2":
                addTask(tasks: &tasks)
                saveTasks(tasks: tasks, to: fileURL)
            case "3":
                completeTask(tasks: &tasks)
                saveTasks(tasks: tasks, to: fileURL)
            case "4":
                removeTask(tasks: &tasks)
                saveTasks(tasks: tasks, to: fileURL)
            case "5":
                print("Koniec programu.")
                isRunning = false
            default:
                print("Nieznana opcja.")
            }
        }
    }
}

main()