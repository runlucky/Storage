import Foundation

class MemoryStorage: IStorage {
    private var storage: [String: Data] = [:]
    private let queue = DispatchQueue(label: "OnMemoryStorage", attributes: .concurrent)
    
    
    func get<T: Codable>(key: String, type: T.Type) throws -> T? {
        var data: Data?
        queue.sync {
            data = storage[key]
        }
        
        guard let data = data else { return nil }
        return try JSONDecoder().decode(type, from: data)
    }
    
    func upsert<T: Codable>(key: String, value: T) throws {
        let data = try JSONEncoder().encode(value)
        
        queue.async (flags: .barrier) {
            self.storage[key] = data
        }
    }

    func delete(key: String) throws {
        queue.async (flags: .barrier) {
            self.storage.removeValue(forKey: key)
        }
    }
    
    func deleteAll() throws {
        storage = [:]
    }
    
    
}
