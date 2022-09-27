import XCTest

@testable import Storage

final class SerialTests: XCTestCase {
    private let memoryStorage = MemoryStorage()
    private let fileStorage = FileStorage(.default, root: FileManager.default.documentDirectory)
    private let userDefaultsStorage = UserDefaultsStorage(.standard, bundleIdentifier: Bundle.main.bundleIdentifier ?? "aaa")
    
    override func setUpWithError() throws {
        try memoryStorage.deleteAll()
        try fileStorage.deleteAll()
        try userDefaultsStorage.deleteAll()
    }
    
    func testOnMemorySerial() throws {
        try readWriteTest(memoryStorage)
        try deleteTest(memoryStorage)
    }
    
    func testFileSerial() throws {
        try readWriteTest(fileStorage)
        try deleteTest(fileStorage)
    }
    
    func testUserDefaultsSerial() throws {
        try readWriteTest(userDefaultsStorage)
        try deleteTest(userDefaultsStorage)
    }
    
    func readWriteTest(_ storage: IStorage) throws {
        let key = "testKey", value = "aaa"
        
        try storage.upsert(key: key, value: value)
        let readValue = try? storage.get(key: key, type: String.self)

        XCTAssert(readValue == value)
    }
    
    func deleteTest(_ storage: IStorage) throws {
        let key = "testKey", value = "aaa"

        try storage.upsert(key: key, value: value)
        try storage.delete(key: key)
        if let readValue = try? storage.get(key: key, type: String.self) {
            XCTFail("value exists, [testKey: \(readValue)]")
        }
    }
}
