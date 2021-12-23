import Foundation

private extension String {

    func toSegments() -> Set<Segment> {
        Set(map { Segment(rawValue: String($0))! })
    }
}

extension Day8 {

    static func parseData() -> [Note] {
        Day8.data
            .components(separatedBy: .newlines)
            .map { String($0) }
            .map { $0.components(separatedBy: " | ").map { String($0) } }
            .map {
                // signal, output
                $0.map {
                    // words
                    $0
                        .components(separatedBy: .whitespaces)
                        .map { String($0).toSegments() }
                        .filter { !$0.isEmpty }
                }
            }
            .reduce(into: [Note]()) { partialResult, part in
                partialResult.append(Note(signals: part.first!, output: part.last!))
            }
    }

}

enum Segment: String {

    case a, b, c, d, e, f, g

}

struct Note {

    var signals: [Set<Segment>]
    var output: [Set<Segment>]

}

// Solution:
// With help of this diagram https://imgur.com/a/LIS2zZr
// With help of https://www.reddit.com/r/adventofcode/comments/rbj87a/comment/hnpgp65/

// `1` len = 2
// `4` len = 4
// `7` len = 3
// `8` len = 7

// `2`.intersects(`1`) = 1 `2`.intersects(`4`) = 2 len = 5
// `3`.intersects(`1`) = 2 `3`.intersects(`4`) = 3 len = 5
// `5`.intersects(`1`) = 1 `5`.intersects(`4`) = 3 len = 5

// `0`.intersects(`1`) = 2 `0`.intersects(`4`) = 3 len = 6
// `6`.intersects(`1`) = 1 `6`.intersects(`4`) = 3 len = 6
// `9`.intersects(`1`) = 2 `9`.intersects(`4`) = 4 len = 6

struct Display {

    let length: Int
    var encodedValue = Set<Segment>()

}

class Submarine {

    var displays = [6, 2, 5, 5, 4, 5, 6, 3, 7, 6]

    func decode(from words: [Set<Segment>]) -> [Set<Segment>] {
        words
            .sorted { $0.count < $1.count }
            .reduce(into: Array(repeating: Set<Segment>(), count: displays.count)) { result, word in
            switch word.count {
            case displays[1]: result[1] = word
            case displays[4]: result[4] = word
            case displays[7]: result[7] = word
            case displays[8]: result[8] = word

            case displays[2]:
                if result[1].intersection(word).count == 2 {
                    result[3] = word
                } else {
                    if result[4].intersection(word).count == 2 {
                        result[2] = word
                    } else {
                        result[5] = word
                    }
                }

            case displays[0]:
                if result[1].intersection(word).count == 1 {
                    result[6] = word
                } else {
                    if result[4].intersection(word).count == 3 {
                        result[0] = word
                    } else {
                        result[9] = word
                    }
                }

            default:
                fatalError("Oh noes! Cannot decode display \(word).")
            }
        }
    }

    func toInt(_ word: Set<Segment>, keys: [Set<Segment>]) -> Int? {
        keys.firstIndex(of: word)
    }

}

struct Decoder {

    static func decodeUniqueNumbers(from notes: [Note], submarine: Submarine) -> Int {
        notes
            .map { $0.output }
            .map { $0.filter { [2, 3, 4, 7].contains($0.count) } }
            .map { $0.count }
            .reduce(0, +)
    }

    static func decodeAllOutputs(from notes: [Note], submarine: Submarine) -> Int {
        notes
            .reduce(into: 0) { result, note in
                let displays = submarine.decode(from: (note.signals + note.output))

                result += Int(
                    note.output
                        .map { submarine.toInt($0, keys: displays)! }
                        .map { String($0) }
                        .reduce("", +)
                )!
            }
    }

}

print(Decoder.decodeUniqueNumbers(from: Day8.parseData(), submarine: Submarine()))
print(Decoder.decodeAllOutputs(from: Day8.parseData(), submarine: Submarine()))
