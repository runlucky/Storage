//
//  FileStorage.swift
//  Storage
//
//  Created by Kakeru Fukuda on 2022/09/22.
//

import Foundation

/// 標準ファイル入出力を使用したストレージです
struct FileStorage: IStorage {
    private let fileManager: FileManager
    private let root: URL
    
    init(_ fileManager: FileManager, root: URL) {
        self.fileManager = fileManager
        self.root = root
    }
    
    func get<T: Codable>(key: String, type: T.Type) throws -> T {
        let url = root.appendingPathComponent(key)
        guard fileManager.fileExists(atPath: url.path) else { throw StorageError.notFound(key: key) }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
    
    func upsert<T: Codable>(key: String, value: T) throws {
        let url = root.appendingPathComponent(key)
        let data = try JSONEncoder().encode(value)
        fileManager.createFile(atPath: url.path, contents: data)
    }

    func delete(key: String) throws {
        let url = root.appendingPathComponent(key)
        
        do {
            try fileManager.removeItem(at: url)
        } catch CocoaError.fileNoSuchFile {
            // 削除対象のファイルがなかった場合は例外を握りつぶす
            return
        }
    }
    
    func deleteAll() throws {
        let files = try fileManager.contentsOfDirectory(at: root, includingPropertiesForKeys: nil)
        try files.forEach { try fileManager.removeItem(at: $0) }
    }
}
