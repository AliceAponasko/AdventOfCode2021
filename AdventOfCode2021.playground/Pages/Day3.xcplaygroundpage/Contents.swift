import Foundation

extension Day3 {

    static func parseData() -> [String] {
        Day3.data.components(separatedBy: "\n").map { String($0) }
    }

}

extension StringProtocol {

    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }

}

class Submarine {

    struct Consumption {
        var gamma = ""
        var epsilon = ""

        var power: Int { Int(gamma, radix: 2)! * Int(epsilon, radix: 2)! }
    }

    let consumption: Consumption

    struct Rating {
        var oxygenGenerator = ""
        var co2Scrubber = ""

        var lifeSupport: Int { Int(oxygenGenerator, radix: 2)! * Int(co2Scrubber, radix: 2)! }
    }

    let rating: Rating

    private enum Occurrence {
        case most
        case least
    }

    init(bits: [String]) {
        consumption = Consumption(
            gamma: Submarine.consumption(from: bits, occurrence: .most),
            epsilon: Submarine.consumption(from: bits, occurrence: .least)
        )

        rating = Rating(
            oxygenGenerator: Submarine.rating(from: bits, occurrence: .most),
            co2Scrubber: Submarine.rating(from: bits, occurrence: .least)
        )
    }

    private static func rating(
        from bits: [String],
        occurrence: Occurrence,
        currentPosition: Int = 0
    ) -> String {
        guard bits.count > 1 else {
            return bits.first!
        }

        var numbers = ["0": 0, "1": 0]

        bits.forEach { bit in
            bit.enumerated()
                .filter { $0.offset == currentPosition }
                .forEach { numbers[String($0.element)]! += 1 }
        }

        let commonBit: String
        switch occurrence {
        case .least:
            commonBit = numbers["0"]! <= numbers["1"]! ? "0" : "1"
        case .most:
            commonBit = numbers["0"]! > numbers["1"]! ? "0" : "1"
        }
        let reducedBits = bits.filter { $0[currentPosition] == commonBit }

        return rating(
            from: reducedBits,
            occurrence: occurrence,
            currentPosition: currentPosition + 1
        )
    }

    private static func consumption(
        from bits: [String],
        occurrence: Occurrence
    ) -> String {
        var numbers = Array(repeating: ["0": 0, "1": 0], count: bits.first!.count)

        bits.forEach { bit in
            bit.enumerated().forEach { iterator in
                numbers[iterator.offset][String(iterator.element)]! += 1
            }
        }

        return numbers.reduce(into: "") {
            switch occurrence {
            case .least:
                $0 += $1.max { $0.value > $1.value }!.key
            case .most:
                $0 += $1.max { $0.value < $1.value }!.key
            }
        }
    }

}

let bits = Day3.parseData()
print(Submarine(bits: bits).consumption.power)
print(Submarine(bits: bits).rating.lifeSupport)
