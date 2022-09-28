import XCTest
@testable import Storage

final class HybridStorageTests: StorageTests {
    private var storage: IStorage { MemoryStorage() }
    
    override func setUpWithError() throws {
        try storage.deleteAll()
    }
    
    func testReadWrite() throws {
        try readWriteTest(storage)
    }
    
    func testDelete() throws {
        try deleteTest(storage)
    }
    
    func testDeleteAll() throws {
        try deleteAllTest(storage)
    }
    
    
    func testConcurrent() throws {
        try concurrentTest(storage)
    }
    
    
    func testWritePerformance() throws {
        try writePerformanceTest(storage, 100)
    }
    
    func testReadPerformance() throws {
        try readPerformanceTest(storage, 1000)
    }

    func testDeletePerformance() throws {
        try deletePerformanceTest(storage, 100)
    }
}
