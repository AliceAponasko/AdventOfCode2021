import Foundation

extension Day9 {

    static func parseData() -> [[Int]] {
        Day9.data
            .components(separatedBy: .newlines)
            .map { $0.compactMap { Int(String($0)) } }
    }

}

struct Coordinate: Equatable {

    let x: Int
    let y: Int

    var up: Self { Coordinate(x: x - 1, y: y) }
    var down: Self { Coordinate(x: x + 1, y: y) }
    var left: Self { Coordinate(x: x, y: y - 1) }
    var right: Self { Coordinate(x: x, y: y + 1) }

    func adjacent(upTo max: Int) -> [Coordinate] {
        var neighbors = [Coordinate]()

        (up.x...down.x).forEach { x in
            (left.y...right.y).forEach { y in
                neighbors.append(Coordinate(x: x, y: y))
            }
        }

        neighbors.remove(at: neighbors.firstIndex(of: self)!)

        return neighbors
            .filter { $0.x >= 0 && $0.y >= 0 }
            .filter { $0.x < max && $0.y < max }
    }

}

class Heightmap {

    static func findLowPoints(heights: [[Int]]) -> Int {
        var result = [Int]()

        heights.enumerated().forEach { x, row in
            row.enumerated().forEach { y, height in
                if Coordinate(x: x, y: y)
                    .adjacent(upTo: heights.count)
                    .map({ heights[$0.x][$0.y] })
                    .filter({ $0 <= height })
                    .isEmpty {
                    result.append(height.riskLevel)
                }

            }
        }

        return result.reduce(0, +)
    }

    static func findBasins(heights: [[Int]]) -> Int {
        var result = [Int]()
        var visited = Array(
            repeating: Array(repeating: false, count: heights.count),
            count: heights.count
        )

        heights.enumerated().forEach { x, row in
            row.enumerated().forEach { y, height in
                result.append(
                    findBasin(from: Coordinate(x: x, y: y), in: heights, visited: &visited)
                )
            }
        }

        return result.sorted().suffix(3).reduce(1, *)
    }

    private static func findBasin(
        from c: Coordinate,
        in heights: [[Int]],
        visited: inout [[Bool]]
    ) -> Int {
        guard c.x >= 0, c.y >= 0 else { return 0 }
        guard c.x < heights.count, c.y < heights.count else { return 0 }
        guard !visited[c.x][c.y] else { return 0 }
        guard heights[c.x][c.y] < 9 else { return 0 }

        visited[c.x][c.y] = true
        return 1 +
        findBasin(from: c.up, in: heights, visited: &visited) +
        findBasin(from: c.down, in: heights, visited: &visited) +
        findBasin(from: c.left, in: heights, visited: &visited) +
        findBasin(from: c.right, in: heights, visited: &visited)
    }
    
}

private extension Int {

    var riskLevel: Int { self + 1 }

}

let heights = Day9.parseData()
print(Heightmap.findLowPoints(heights: heights))
print(Heightmap.findBasins(heights: heights))
