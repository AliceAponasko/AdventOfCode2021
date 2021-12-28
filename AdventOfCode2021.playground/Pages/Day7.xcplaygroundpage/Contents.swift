import Foundation

extension Day7 {

    static func parseData() -> [Int] {
        Day7.data.components(separatedBy: ",").compactMap { Int($0) }
    }

}

struct Crabs {

    /// Refactored with https://www.reddit.com/r/adventofcode/comments/rar7ty/comment/hnk43dd/
    /// https://en.wikipedia.org/wiki/Median
    /// https://en.wikipedia.org/wiki/Median#Optimality_property
    static func align(submarines: [Int]) -> Int {
        submarines.map { abs($0 - submarines.sorted(by: <).middle!) }.reduce(0, +)
    }

    /// Refactored with https://www.reddit.com/r/adventofcode/comments/rar7ty/comment/hnk6gz0/
    /// https://en.wikipedia.org/wiki/Triangular_number
    /// https://en.wikipedia.org/wiki/Arithmetic_mean
    static func alignWithTriangularNumbers(submarines: [Int]) -> Int {
        let doubleMean = Double(submarines.reduce(0, +)) / Double(submarines.count)

        return [doubleMean.rounded(.up), doubleMean.rounded(.down)]
            .map { Int($0) }
            .map { mean -> Int in
                submarines
                    .map { submarine -> Int in abs(submarine - mean) }
                    .map { value -> Int in value * (value + 1) / 2 }
                    .reduce(0, +)
            }
            .min()!
    }

}

print(Crabs.align(submarines: Day7.parseData()))
print(Crabs.alignWithTriangularNumbers(submarines: Day7.parseData()))
