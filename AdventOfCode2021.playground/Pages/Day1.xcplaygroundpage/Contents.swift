import Foundation

extension Day1 {

    static func parseData() -> [Int] {
        Day1.data.components(separatedBy: .newlines).compactMap { Int($0) }
    }

}

extension Array where Element == Int {

    func countIncreases(windowSize: Int = 1) -> Int {
        let windows = enumerated()
            .filter { $0.offset <= (count - windowSize) }
            .map { Array(self[$0.offset..<($0.offset + windowSize)]).reduce(0, +) }

        return zip(windows.dropFirst(), windows).map(-).count { $0 > 0 }
    }

}

print(Day1.parseData().countIncreases())
print(Day1.parseData().countIncreases(windowSize: 3))
