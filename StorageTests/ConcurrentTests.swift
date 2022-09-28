//
//  StorageTests.swift
//  StorageTests
//
//  Created by Kakeru Fukuda on 2022/09/22.
//

import XCTest

@testable import Storage

final class ConcurrentTests: XCTestCase {
    private let memoryStorage = MemoryStorage()
    private let fileStorage = FileStorage(.default, root: FileManager.default.documentDirectory)
    private let userDefaultsStorage = UserDefaultsStorage(.standard, bundleIdentifier: Bundle.main.bundleIdentifier ?? "aaa")
    private let keychainStorage = KeychainStorage(serviceIdentifier: Bundle.main.bundleIdentifier ?? "aaa")

    override func setUpWithError() throws {
        try memoryStorage.deleteAll()
        try fileStorage.deleteAll()
        try userDefaultsStorage.deleteAll()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testOnMemoryConcurrent() throws {
        try concurrentTest(memoryStorage)
    }

    func testFileConcurrent() throws {
        try concurrentTest(fileStorage)
    }
    
    func testUserDefaultsConcurrent() throws {
        try concurrentTest(userDefaultsStorage)
    }
    
    func testKeychainConcurrent() throws {
        try concurrentTest(keychainStorage)
    }
    
    func concurrentTest(_ storage: IStorage) throws {
        let queue = DispatchQueue(label: "ioTest", attributes: .concurrent)
        let expect = expectation(description: "IOTest2")
        let iterations = 10000
        
        (0...iterations)
            .forEach { n in
                queue.async {
                    try! storage.upsert(key: n.description, value: n)
                }
            }
        
        while try storage.get(key: iterations.description, type: Int.self) != iterations { }
        
        expect.fulfill()
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
    }
}
