import Foundation

extension Day6 {

    static func parseData() -> [Int] {
        Day6.data.components(separatedBy: ",").map { Int($0)! }
    }

}

struct Lanternfish {

    struct Cycle {
        static let delivery = 0
        static let adult = 6
        static let newborn = 8
    }

    let initialPopulation: [Int]

    func simulate(days: Int) -> Int {
        var ageBuckets = Array(repeating: 0, count: Cycle.newborn + 1)
        initialPopulation.forEach { ageBuckets[$0] += 1 }

        (0..<days).forEach { _ in
            ageBuckets.enumerated().forEach { timer, bucket in
                if timer == Cycle.delivery {
                    ageBuckets[Cycle.delivery] = 0
                    ageBuckets[Cycle.adult] += bucket
                    ageBuckets[Cycle.newborn] += bucket
                } else {
                    ageBuckets[timer - 1] += bucket
                    ageBuckets[timer] -= bucket

                }
            }
        }

        return ageBuckets.reduce(0, +)
    }

}

print(Lanternfish(initialPopulation: Day6.parseData()).simulate(days: 80))
print(Lanternfish(initialPopulation: Day6.parseData()).simulate(days: 256))
