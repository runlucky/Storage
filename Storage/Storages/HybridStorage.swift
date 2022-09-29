//
//  HybridStorage.swift
//  Storage
//
//  Created by Kakeru Fukuda on 2022/09/26.
//

import Foundation

/// 高速・省メモリ・永続的なストレージです
class HybridStorage: IStorage {
    /// 高速ストレージ
    private let fastStorage: IStorage
    /// 永続的ストレージ
    private let persistenceStorage: IStorage
    
    private let upsertInterval: TimeInterval
        
    private let waitingList: WaitingList = WaitingList()
    
    /// - Parameters:
    ///   - fastStorage: 高速に動作するが永続性が無いストレージ
    ///   - persistenceStorage: 低速だが永続的なストレージ
    ///   - upsertInterval: 永続化を行う時の遅延
    init(fastStorage: IStorage, persistenceStorage: IStorage, upsertInterval: TimeInterval) {
        self.fastStorage = fastStorage
        self.persistenceStorage = persistenceStorage
        self.upsertInterval = upsertInterval
    }
    
    func get<T: Codable>(key: String, type: T.Type) throws -> T? {
        if let value = try? fastStorage.get(key: key, type: type) {
            return value
        }
        
        if let value = try persistenceStorage.get(key: key, type: type) {
            try fastStorage.upsert(key: key, value: value)
            return value
        }
        
        return nil
    }

    /// 高速化のため書き込まれたデータはすぐには永続化されません
    func upsert<T: Codable>(key: String, value: T) throws {
        // todo: 高速ストレージへの書き込みは省メモリのため、たまに古いデータを削除する必要がある
        try fastStorage.upsert(key: key, value: value)
        
        if waitingList.isWaiting(key) { return }
        waitingList.add(key)
        Task {
            await Task.sleep(timeInterval: upsertInterval)
            let value = try fastStorage.get(key: key, type: T.self)
            try persistenceStorage.upsert(key: key, value: value)
            waitingList.delete(key)
        }
    }

    
    func delete(key: String) throws {
        try fastStorage.delete(key: key)
        try persistenceStorage.delete(key: key)
    }

    func deleteAll() throws {
        try fastStorage.deleteAll()
        try persistenceStorage.deleteAll()
    }
}


fileprivate class WaitingList {
    private var list: [String: Bool] = [:]
    
    fileprivate func isWaiting(_ key: String) -> Bool {
        list[key] == true
    }
    
    fileprivate func add(_ key: String) {
        list[key] = true
    }
    
    fileprivate func delete(_ key: String) {
        list.removeValue(forKey: key)
    }
}
