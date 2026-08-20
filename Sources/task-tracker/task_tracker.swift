import Foundation

// ANSI color codes for nicer terminal output
let RESET = "\u{001B}[0m"
let BOLD = "\u{001B}[1m"
let DIMMED = "\u{001B}[2m"
let GREEN = "\u{001B}[32m"
let RED = "\u{001B}[31m"
let YELLOW = "\u{001B}[33m"
let CYAN = "\u{001B}[36m"
let MAGENTA = "\u{001B}[35m"

// Box drawing characters
let BOX_TL = "\u{250C}" // ┌
let BOX_TR = "\u{2510}" // ┐
let BOX_BL = "\u{2514}" // └
let BOX_BR = "\u{2518}" // ┘
let BOX_H = "\u{2500}"  // ─
let BOX_V = "\u{2502}"  // │

struct Task: Codable {
    var title: String
    var isDone: Bool
    var priority: Int // 1 = high, 2 = medium (default), 3 = low
}

/// Counts the visible characters of a string, ignoring ANSI escape sequences
/// like `\u{001B}[32m` so colored text aligns correctly inside boxes.
func visibleCount(_ s: String) -> Int {
    var count = 0
    var inEscape = false
    for ch in s {
        if inEscape {
            if ch == "m" { inEscape = false }
            continue
        }
        if ch == "\u{001B}" {
            inEscape = true
            continue
        }
        count += 1
    }
    return count
}

/// Prints a box with the given lines, automatically sizing to the widest line.
/// Lines may contain ANSI colors — they are ignored for width calculation.
func printBox(lines: [String]) {
    let contentWidth = lines.map { visibleCount($0) }.max() ?? 0
    print("\(CYAN)\(BOX_TL)\(String(repeating: BOX_H, count: contentWidth + 2))\(BOX_TR)\(RESET)")
    for line in lines {
        let width = visibleCount(line)
        print("\(CYAN)\(BOX_V)\(RESET) \(line)\(String(repeating: " ", count: max(0, contentWidth - width))) \(CYAN)\(BOX_V)\(RESET)")
    }
    print("\(CYAN)\(BOX_BL)\(String(repeating: BOX_H, count: contentWidth + 2))\(BOX_BR)\(RESET)")
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
    printBox(lines: [
        " \(BOLD)\(CYAN)TASK TRACKER\(RESET)",
        "",
        "  \(BOLD)1.\(RESET) Pokaż zadania",
        "  \(BOLD)2.\(RESET) Dodaj zadanie",
        "  \(BOLD)3.\(RESET) Oznacz jako zrobione",
        "  \(BOLD)4.\(RESET) Usuń zadanie",
        "  \(BOLD)5.\(RESET) Wyjście"
    ])
    print(" \(DIMMED)Wybierz opcję:\(RESET) ", terminator: "")
}

func showTasks(tasks: [Task]) {
    if tasks.isEmpty {
        printBox(lines: [
            " \(YELLOW)⚠ Brak zadań.\(RESET)",
            "",
            " \(DIMMED)Dodaj pierwsze zadanie (opcja 2).\(RESET)"
        ])
        return
    }

    let doneCount = tasks.filter { $0.isDone }.count
    let total = tasks.count
    let percent = Int((Double(doneCount) / Double(total)) * 100)

    var lines: [String] = [
        " \(BOLD)\(CYAN)LISTA ZADAŃ\(RESET)",
        ""
    ]

    for i in 0..<tasks.count {
        let status = tasks[i].isDone ? "\(GREEN)✓\(RESET)" : "\(DIMMED)•\(RESET)"
        let label = priorityLabel(tasks[i].priority)
        let title = tasks[i].title
        let color: String
        if tasks[i].isDone {
            color = DIMMED
        } else {
            color = priorityColor(tasks[i].priority)
        }
        lines.append("  \(status) \(label) \(color)\(title)\(RESET)")
    }

    lines.append("")
    let barWidth = 20
    let filled = Int((Double(doneCount) / Double(total)) * Double(barWidth))
    let bar = String(repeating: "█", count: filled) + String(repeating: "░", count: barWidth - filled)
    let barColor = percent == 100 ? GREEN : (percent >= 50 ? YELLOW : CYAN)
    lines.append(" \(BOLD)Postęp:\(RESET) \(barColor)\(bar)\(RESET) \(doneCount)/\(total) (\(percent)%)")

    printBox(lines: lines)
}

func addTask(tasks: inout [Task]) {
    print(" \(BOLD)Podaj nazwę zadania:\(RESET) ", terminator: "")

    guard let title = readLine() else {
        printBox(lines: [" \(RED)✖ Nazwa zadania nie może być pusta.\(RESET)"])
        return
    }
    let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty {
        printBox(lines: [" \(RED)✖ Nazwa zadania nie może być pusta.\(RESET)"])
        return
    }

    print(" \(BOLD)Priorytet\(RESET) (1 = wysoki, 2 = średni, 3 = niski): ", terminator: "")
    var priority = 2
    if let input = readLine(), let number = Int(input), (1...3).contains(number) {
        priority = number
    } else {
        printBox(lines: [" \(YELLOW)⚠ Nieprawidłowy priorytet, ustawiam domyślny (średni).\(RESET)"])
    }

    let task = Task(title: trimmed, isDone: false, priority: priority)
    tasks.append(task)
    printBox(lines: [" \(GREEN)✓ Dodano zadanie.\(RESET)"])
}

func completeTask(tasks: inout [Task]) {
    showTasks(tasks: tasks)

    if tasks.isEmpty {
        return
    }

    print(" \(BOLD)Podaj numer zadania do oznaczenia:\(RESET) ", terminator: "")

    if let input = readLine(), let number = Int(input) {
        if number >= 1 && number <= tasks.count {
            tasks[number - 1].isDone = true
            printBox(lines: [" \(GREEN)✓ Zadanie oznaczone jako zrobione.\(RESET)"])
        } else {
            printBox(lines: [" \(RED)✖ Nieprawidłowy numer.\(RESET)"])
        }
    } else {
        printBox(lines: [" \(RED)✖ Wpisz poprawną liczbę.\(RESET)"])
    }
}

func removeTask(tasks: inout [Task]) {
    showTasks(tasks: tasks)

    if tasks.isEmpty {
        return
    }

    print(" \(BOLD)Podaj numer zadania do usunięcia:\(RESET) ", terminator: "")

    if let input = readLine(), let number = Int(input) {
        if number >= 1 && number <= tasks.count {
            tasks.remove(at: number - 1)
            printBox(lines: [" \(GREEN)✓ Zadanie usunięte.\(RESET)"])
        } else {
            printBox(lines: [" \(RED)✖ Nieprawidłowy numer.\(RESET)"])
        }
    } else {
        printBox(lines: [" \(RED)✖ Wpisz poprawną liczbę.\(RESET)"])
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
                printBox(lines: [" \(RED)✖ Nieznana opcja.\(RESET)"])
            }
        }
    }
}

main()