//
//  UserDefaultsStorage.swift
//  Storage
//
//  Created by Kakeru Fukuda on 2022/09/22.
//

import Foundation

/// UserDefaultsを使用したストレージです
struct UserDefaultsStorage: IStorage {
    private let userDefaults: UserDefaults
    private let bundleIdentifier: String
    
    init(_ userDefaults: UserDefaults, bundleIdentifier: String) {
        self.userDefaults = userDefaults
        self.bundleIdentifier = bundleIdentifier
    }
    
    func get<T: Codable>(key: String, type: T.Type) throws -> T {
        guard let data = userDefaults.data(forKey: key) else { throw StorageError.notFound(key: key)  }
        return try JSONDecoder().decode(type, from: data)
    }
    
    func upsert<T: Codable>(key: String, value: T) throws {
        let data = try JSONEncoder().encode(value)
        userDefaults.set(data, forKey: key)
    }

    func delete(key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
    
    func deleteAll() throws {
        userDefaults.removePersistentDomain(forName: bundleIdentifier)
    }
}
