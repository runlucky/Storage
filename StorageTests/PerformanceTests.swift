//
//  PerformanceTests.swift
//  StorageTests
//
//  Created by Kakeru Fukuda on 2022/09/26.
//

import XCTest
@testable import Storage

final class PerformanceTests: XCTestCase {
    private let memoryStorage = MemoryStorage()
    private let fileStorage = FileStorage(.default, root: .documentsDirectory)
    private let userDefaultsStorage = UserDefaultsStorage(.standard, bundleIdentifier: Bundle.main.bundleIdentifier ?? "aaa")
    
    override func setUpWithError() throws {
        try memoryStorage.deleteAll()
        try fileStorage.deleteAll()
        try userDefaultsStorage.deleteAll()
    }

    func testWriteMemory() throws {
        self.measure {
            do {
                try writeTest(memoryStorage, 100)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func testWriteFile() throws {
        self.measure {
            do {
                try writeTest(fileStorage, 100)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func testWriteUserDefaults() throws {
        self.measure {
            do {
                try writeTest(userDefaultsStorage, 100)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func testReadMemory() throws {
        self.measure {
            do {
                try readTest(memoryStorage, 1000)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func testReadFile() throws {
        self.measure {
            do {
                try readTest(fileStorage, 1000)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func testReadUserDefaults() throws {
        self.measure {
            do {
                try readTest(userDefaultsStorage, 1000)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    func testDeleteMemory() throws {
        self.measure {
            do {
                try deleteTest(memoryStorage, 100)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func testDeleteFile() throws {
        self.measure {
            do {
                try deleteTest(fileStorage, 100)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func testDeleteUserDefaults() throws {
        self.measure {
            do {
                try deleteTest(userDefaultsStorage, 100)
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    func writeTest(_ storage: IStorage, _ iterations: Int) throws {
        let value = getText(1000)
        
        try (0...iterations).forEach { _ in
            try (0...10).forEach { n in
                try storage.upsert(key: n.description, value: value)
            }
        }
    }
    
    func readTest(_ storage: IStorage, _ iterations: Int) throws {
        let value = getText(1000)
        
        try (0...10).forEach { n in
            try storage.upsert(key: n.description, value: value)
        }
        
        try (0...iterations).forEach { _ in
            try (0...10).forEach { n in
                _ = try storage.get(key: n.description, type: String.self)
            }
        }
    }
    
    func deleteTest(_ storage: IStorage, _ iterations: Int) throws {
        let value = getText(1000)
        
        try (0...iterations).forEach { _ in
            try (0...10).forEach { n in
                try storage.upsert(key: n.description, value: value)
                try storage.delete(key: n.description)
            }
        }
    }
    

    
    func getText(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        return (0...length).reduce("") { result, _ in
            result + String(letters.randomElement()!)
        }
    }

}
