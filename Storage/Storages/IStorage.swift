//
//  IStorage.swift
//  Storage
//
//  Created by Kakeru Fukuda on 2022/09/22.
//

import Foundation

protocol IStorage {
    func get<T: Codable>(key: String, type: T.Type) throws -> T?
    func upsert<T: Codable>(key: String, value: T) throws
    func delete(key: String) throws
    func deleteAll() throws
}
