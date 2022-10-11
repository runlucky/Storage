import XCTest
@testable import Storage

class StorageTests: XCTestCase {
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
        
        while (try? storage.get(key: iterations.description, type: Int.self)) != iterations { }
        
        expect.fulfill()
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
    }
    
    
    func writePerformanceTest(_ storage: IStorage, _ iterations: Int) throws {
        let value = getText(1000)
        
        self.measure {
            do {
                try (0...iterations).forEach { _ in
                    try (0...10).forEach { n in
                        try storage.upsert(key: n.description, value: value)
                    }
                }
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func readPerformanceTest(_ storage: IStorage, _ iterations: Int) throws {
        let value = getText(1000)
        
        try (0...10).forEach { n in
            try storage.upsert(key: n.description, value: value)
        }
        
        self.measure {
            do {
                try (0...iterations).forEach { _ in
                    try (0...10).forEach { n in
                        _ = try storage.get(key: n.description, type: String.self)
                    }
                }
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    func deletePerformanceTest(_ storage: IStorage, _ iterations: Int) throws {
        let value = getText(1000)

        self.measure {
            do {
                try (0...iterations).forEach { _ in
                    try (0...10).forEach { n in
                        try storage.upsert(key: n.description, value: value)
                        try storage.delete(key: n.description)
                    }
                }
            } catch {
                XCTAssertThrowsError(error)
            }
        }
    }
    
    private func getText(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        return (0...length).reduce("") { result, _ in
            result + String(letters.randomElement()!)
        }
    }

}
