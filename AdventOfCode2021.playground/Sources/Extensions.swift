extension Array {

    public var middle: Element? { isEmpty ? nil : self[count / 2] }

    public mutating func append(_ element: Element?) {
        guard let element = element else { return }
        append(element)
    }

}

extension Collection {

    // From https://stackoverflow.com/a/30593673
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

}

extension Sequence {

    public func count(where condition: (Element) throws -> (Bool)) rethrows -> Int {
        try reduce(0) { try condition($1) ? $0 + 1 : $0 }
    }

}
