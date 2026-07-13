# Swift Task Tracker CLI

A simple task tracker written in Swift as a beginner project for learning programming fundamentals and working with terminal applications.

## Features

- Show all tasks
- Add a new task
- Mark a task as completed
- Remove a task
- Save tasks to a JSON file (`tasks.json` in the current directory)
- Load tasks after restarting the app
- Task priorities (high, medium, low)
- Input validation for empty titles, invalid numbers, and out-of-range priorities
- Colored terminal output (green for done, red for high priority, yellow for medium)
- Simple interactive terminal menu

## Tech Stack

- Swift
- Swift Package Manager
- VS Code
- Linux

## Getting Started

Clone the repository:

```bash
git clone https://github.com/w3ziqv/swift-task-tracker-cli.git
cd swift-task-tracker-cli
swift run
```

## Example Menu

```text
=== TASK TRACKER ===
1. Pokaż zadania
2. Dodaj zadanie
3. Oznacz jako zrobione
4. Usuń zadanie
5. Wyjście
Wybierz opcję:
```

When adding a task, the app also asks for a priority:

```text
Podaj nazwę zadania:
Nauczyć się Swifta
Priorytet (1 = wysoki, 2 = średni, 3 = niski):
1
```

## Why I Built This

This project was created as part of learning Swift from scratch.  
It helped me practice:

- functions,
- loops,
- conditionals,
- structs,
- arrays,
- user input handling,
- file I/O with `FileManager` and `JSONEncoder` / `JSONDecoder`,
- encoding and decoding data with `Codable`,
- building a simple CLI application.

## Future Improvements

Planned next steps:

- make terminal output nicer.

## License

MIT