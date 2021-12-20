import Foundation

extension Day1 {

    static func parseData() -> [Int] {
        Day1.data.components(separatedBy: "\n").compactMap { Int($0) }
    }

}

extension Array where Element == Int {

    func countIncreases(windowSize: Int = 1) -> Int {
        let windows = enumerated()
            .filter { $0.offset <= (count - windowSize) }
            .reduce(into: [Int]()) {
                $0.append(
                    Array(self[$1.offset..<($1.offset + windowSize)]).reduce(0, +)
                )
            }

        return zip(windows.dropFirst(), windows).map(-).filter { $0 > 0 }.count
    }

}

print(Day1.parseData().countIncreases())
print(Day1.parseData().countIncreases(windowSize: 3))
