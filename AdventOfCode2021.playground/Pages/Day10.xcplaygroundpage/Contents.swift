import Foundation

extension Day10 {

    static func parseData() -> [String] {
        Day10.data.components(separatedBy: .newlines).map { String($0) }
    }

}

enum Opening: String, CaseIterable {
    case round = "("
    case square = "["
    case curly = "{"
    case angle = "<"

    var matching: Closing {
        switch self {
        case .round: return Closing.round
        case .square: return Closing.square
        case .curly: return Closing.curly
        case .angle: return Closing.angle
        }
    }

    static func contains(_ letter: String) -> Bool {
        Opening.allCases.contains { $0.rawValue == letter }
    }

}

enum Closing: String, CaseIterable {
    case round = ")"
    case square = "]"
    case curly = "}"
    case angle = ">"

    var autocompletePoints: Int {
        switch self {
        case .round: return 1
        case .square: return 2
        case .curly: return 3
        case .angle: return 4
        }
    }

    var syntaxPoints: Int {
        switch self {
        case .round: return 3
        case .square: return 57
        case .curly: return 1197
        case .angle: return 25137
        }
    }

}

struct Submarine {

    static func validateCorrupted(_ subsystem: [String]) -> Int {
        subsystem
            .compactMap { validateCorrupted($0) }
            .reduce(0, +)
    }

    static func validateIncomplete(_ subsystem: [String]) -> Int {
        subsystem
            .filter { validateCorrupted($0) == nil }
            .map { complete($0) }
            .sorted(by: <)
            .middle!
    }

    private static func complete(_ navigation: String) -> Int {
        navigation
            .map { String($0) }
            .reduce(into: [String]()) {
                if Opening.contains($1) {
                    $0.append($1)
                } else {
                    $0.removeLast()
                }
            }
            .reversed()
            .reduce(into: 0) {
                $0 = $0 * 5 + Opening(rawValue: $1)!.matching.autocompletePoints
            }
    }

    private static func validateCorrupted(_ navigation: String) -> Int? {
        var stack = [String]()

        for letter in navigation.map({ String($0) }) {
            if Opening.contains(letter) {
                stack.append(letter)
            } else {
                if Opening(rawValue: stack.last!)!.matching.rawValue == letter {
                    stack.removeLast()
                } else {
                    return Closing(rawValue: letter)!.syntaxPoints
                }
            }

        }

        return nil
    }

}

print(Submarine.validateCorrupted(Day10.parseData()))
print(Submarine.validateIncomplete(Day10.parseData()))
