import Foundation

class KeychainStorage: IStorage {
    func get<T: Codable>(key: String, type: T.Type) throws -> T? {
//        let url = root.appendingPathComponent(key)
//        guard fileManager.fileExists(atPath: url.path) else { return nil }
//        let data = try Data(contentsOf: url)
//        return try JSONDecoder().decode(type, from: data)
        nil
    }
    
    func upsert<T: Codable>(key: String, value: T) throws {
//        let url = root.appendingPathComponent(key)
//        let data = try JSONEncoder().encode(value)
//        fileManager.createFile(atPath: url.path, contents: data)
    }

    func delete(key: String) throws {
//        let url = root.appendingPathComponent(key)
//        try fileManager.removeItem(at: url)
    }
    
    func deleteAll() throws {
//        let files = try fileManager.contentsOfDirectory(at: root, includingPropertiesForKeys: nil)
//        try files.forEach { try fileManager.removeItem(at: $0) }
    }
}
