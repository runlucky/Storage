import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(timeInterval: TimeInterval) async {
        try? await Task.sleep(nanoseconds: UInt64(timeInterval * 1_000_000_000))
    }
}
