extension Array {

    public mutating func append(_ element: Element?) {
        guard let element = element else { return }
        append(element)
    }

}

extension Sequence {

    public func count(where condition: (Element) throws -> (Bool)) rethrows -> Int {
        try reduce(0) { try condition($1) ? $0 + 1 : $0 }
    }

}
