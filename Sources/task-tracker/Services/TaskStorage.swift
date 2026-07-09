import Foundation

/// Service for storing and loading tasks from a JSON file
class TaskStorage {
    private let fileURL: URL
    
    init(fileName: String = "tasks.json") {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documentsDirectory.appendingPathComponent(fileName)
    }
    
    /// Save tasks to JSON file
    /// - Parameter tasks: Array of tasks to save
    /// - Throws: Error if saving fails
    func save(tasks: [Task]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(tasks)
        try data.write(to: fileURL)
    }
    
    /// Load tasks from JSON file
    /// - Returns: Array of loaded tasks, or empty array if file doesn't exist
    func load() -> [Task] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let tasks = try decoder.decode([Task].self, from: data)
            return tasks
        } catch {
            print("Error loading tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Delete the tasks file
    func deleteFile() throws {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}
