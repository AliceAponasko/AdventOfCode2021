import Foundation

extension Day5 {

    static func parseData() -> [Line] {
        Day5.data
            .components(separatedBy: .newlines)
            .map { String($0) }
            .reduce(into: [Line]()) { partialResult, line in
                let coordinates = line
                    .components(separatedBy: " -> ")
                    .map { String($0) }
                    .map { $0.components(separatedBy: ",") }
                    .map { Coordinate(x: $0.first, y: $0.last) }

                partialResult.append(Line(coordinates.first!, coordinates.last!))
            }
    }

}

struct Coordinate: Hashable {

    var x: Int
    var y: Int

    init(x: String?, y: String?) {
        guard let row = x, let column = y,
              let rowNumber = Int(row), let columnNumber = Int(column)
        else {
            fatalError("Cannot make a coordinate with \(x ?? "") and \(y ?? "").")
        }

        self.x = rowNumber
        self.y = columnNumber
    }

    mutating func move(in line: Line) -> Self {
        if line.start.x != line.end.x {
            x += line.start.x < line.end.x ? 1 : -1
        }

        if line.start.y != line.end.y {
            y += line.start.y < line.end.y ? 1 : -1
        }

        return self
    }

}

class Line {

    var start: Coordinate
    var end: Coordinate

    lazy var isHorizontal: Bool = { start.y == end.y }()
    lazy var isVertical: Bool = { start.x == end.x }()

    init(_ start: Coordinate, _ end: Coordinate) {
        self.start = start
        self.end = end
    }

}

class Field {

    static func dangerousAreas(_ lines: [Line], withDiagonal: Bool = true) -> Int {
        (withDiagonal ? lines : lines.filter { $0.isHorizontal || $0.isVertical })
            .reduce(into: [Coordinate: Int]()) { vents, line in
                var coordinate = line.start
                vents[coordinate, default: 0] += 1

                while coordinate != line.end {
                    vents[coordinate.move(in: line), default: 0] += 1
                }
            }
            .count { $0.value > 1 }
    }

}

let ventLines = Day5.parseData()
print(Field.dangerousAreas(ventLines, withDiagonal: false))
print(Field.dangerousAreas(ventLines))
