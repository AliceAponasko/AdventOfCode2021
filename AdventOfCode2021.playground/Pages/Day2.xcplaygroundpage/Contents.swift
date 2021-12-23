import Foundation

extension Day2 {

    static func parseData() -> [Direction] {
        Day2.data
            .components(separatedBy: .newlines)
            .map { String($0).components(separatedBy: .whitespaces) }
            .map { Direction(direction: $0.first!, points: Int($0.last!)!) }
    }

}

enum Direction {

    case horizontal(points: Int)
    case vertical(points: Int)

    init(direction: String, points: Int) {
        switch direction {
        case "forward":
            self = .horizontal(points: points)
        case "down":
            self = .vertical(points: points)
        case "up":
            self = .vertical(points: -points)
        default:
            fatalError("Cannot make a direction out of \(direction)")
        }
    }

}

struct Submarine {

    struct Position {
        var horizontal = 0
        var vertical = 0
        var aim = 0
    }

    static func move(in directions: [Direction], withAim: Bool = false) -> Position {
        directions.reduce(into: Position()) { position, direction in
            switch direction {
            case let .horizontal(points):
                position.horizontal += points

                if withAim {
                    position.vertical += position.aim * points
                }

            case let .vertical(points):
                position.aim += points

                if !withAim {
                    position.vertical += points
                }
            }
        }
    }

}

let directions = Day2.parseData()
let positionNoAim = Submarine.move(in: directions)
let positionWithAim = Submarine.move(in: directions, withAim: true)

print(positionNoAim.horizontal * positionNoAim.vertical)
print(positionWithAim.horizontal * positionWithAim.vertical)
