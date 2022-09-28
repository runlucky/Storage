import XCTest

@testable import Storage

final class SerialTests: XCTestCase {
    private let memoryStorage = MemoryStorage()
    private let fileStorage = FileStorage(.default, root: FileManager.default.documentDirectory)
    private let userDefaultsStorage = UserDefaultsStorage(.standard, bundleIdentifier: Bundle.main.bundleIdentifier ?? "aaa")
    private let keychainStorage = KeychainStorage(serviceIdentifier: Bundle.main.bundleIdentifier ?? "aaa")
    
    override func setUpWithError() throws {
        try memoryStorage.deleteAll()
        try fileStorage.deleteAll()
        try userDefaultsStorage.deleteAll()
    }
    
    func testOnMemorySerial() throws {
        try readWriteTest(memoryStorage)
        try deleteTest(memoryStorage)
        try deleteAllTest(memoryStorage)
    }
    
    func testFileSerial() throws {
        try readWriteTest(fileStorage)
        try deleteTest(fileStorage)
        try deleteAllTest(fileStorage)
    }
    
    func testUserDefaultsSerial() throws {
        try readWriteTest(userDefaultsStorage)
        try deleteTest(userDefaultsStorage)
        try deleteAllTest(userDefaultsStorage)
    }
    
    func testKeychainSerial() throws {
        try readWriteTest(keychainStorage)
        try deleteTest(keychainStorage)
        try deleteAllTest(keychainStorage)
    }
    
    func readWriteTest(_ storage: IStorage) throws {
        let key = UUID().uuidString, value = UUID().uuidString
        
        try storage.upsert(key: key, value: value)
        let readValue = try? storage.get(key: key, type: String.self)

        XCTAssert(readValue == value)
    }
    
    func deleteTest(_ storage: IStorage) throws {
        let key = UUID().uuidString, value = UUID().uuidString

        try storage.upsert(key: key, value: value)
        try storage.delete(key: key)
        if let readValue = try? storage.get(key: key, type: String.self) {
            XCTFail("value exists, [\(key): \(readValue)]")
        }
    }
    
    func deleteAllTest(_ storage: IStorage) throws {
        let keys = (0...10).map { _ in UUID().uuidString }
        
        try keys.forEach { key in
            try storage.upsert(key: key, value: UUID().uuidString)
        }
        
        try storage.deleteAll()
        
        keys.forEach { key in
            if let readValue = try? storage.get(key: key, type: UUID.self) {
                XCTFail("value exists, [\(key): \(readValue)]")
            }
        }
    }
}
