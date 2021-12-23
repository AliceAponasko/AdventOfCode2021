import Foundation

extension Day4 {

    static func parseData() -> (DrawingNumbers, [Board]) {
        var components = Day4.data.components(separatedBy: "\n\n").map { String($0) }

        return (
            components.removeFirst()
                .components(separatedBy: ",")
                .compactMap { Int($0) },
            components.reduce(into: [Board]()) { resultBoards, board in
                resultBoards.append(
                    board.components(separatedBy: .newlines)
                        .reduce(into: Board()) { resultBoard, line in
                            resultBoard.grid.append(
                                line
                                    .components(separatedBy: " ")
                                    .filter { $0 != "" }
                                    .compactMap { Int($0) }
                                    .map { Board.Number($0) }
                            )
                        }
                )
            }
        )
    }

}

class Board {

    class Number {
        var value: Int
        var marked = false

        init(_ value: Int) {
            self.value = value
        }
    }

    var grid = [[Number]]()

    var finished: Bool {
        for (index, line) in grid.enumerated() {
            if check(line: line) || check(line: columns[index]) {
                return true
            }
        }

        return false
    }

    var score: Int {
        grid.map { $0.filter { !$0.marked }.map { $0.value }.reduce(0, +) }.reduce(0, +)
    }

    private lazy var columns: [[Number]] = {
        grid.enumerated().map { column(at: $0.offset) }
    }()

    @discardableResult
    func mark(_ n: Int) -> Bool {
        for line in grid {
            for number in line {
                if number.value == n {
                    number.marked = true

                    if finished {
                        return true
                    }
                }
            }
        }

        return false
    }

    private func check(line: [Number]) -> Bool {
        line.count == line.count { $0.marked }
    }

    private func column(at index: Int) -> [Number] {
        grid.map { $0[index] }
    }

}

typealias DrawingNumbers = [Int]

struct Bingo {

    static func play(drawingNumbers: DrawingNumbers, boards: [Board]) -> Int {
        for drawingNumber in drawingNumbers {
            for board in boards {
                if board.mark(drawingNumber) {
                    return board.score * drawingNumber
                }
            }
        }

        return 0
    }

    static func playLast(drawingNumbers: DrawingNumbers, boards: [Board]) -> Int {
        var lastBoard: Board!
        var lastNumber: Int!

        for drawingNumber in drawingNumbers {
            for board in boards {
                if !board.finished {
                    board.mark(drawingNumber)
                    lastBoard = board
                    lastNumber = drawingNumber
                }
            }
        }

        return lastBoard.score * lastNumber
    }

}

let (drawingNumbers, boards) = Day4.parseData()
print(Bingo.play(drawingNumbers: drawingNumbers, boards: boards))
print(Bingo.playLast(drawingNumbers: drawingNumbers, boards: boards))
