struct Task {
    var title: String
    var isDone: Bool
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
            print("\(i + 1). \(status) \(tasks[i].title)")
        }
    }
}

func addTask(tasks: inout [Task]) {
    print("Podaj nazwę zadania:")
    
    if let title = readLine(), !title.isEmpty {
        let task = Task(title: title, isDone: false)
        tasks.append(task)
        print("Dodano zadanie.")
    } else {
        print("Nazwa zadania nie może być pusta.")
    }
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

func main() {
    var tasks: [Task] = []
    var isRunning = true
    
    while isRunning {
        showMenu()
        
        if let choice = readLine() {
            switch choice {
            case "1":
                showTasks(tasks: tasks)
            case "2":
                addTask(tasks: &tasks)
            case "3":
                completeTask(tasks: &tasks)
            case "4":
                removeTask(tasks: &tasks)
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