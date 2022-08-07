import Algorithms

extension Array where Element == UInt8 {
    public init?<S>(hexString: S) where S: StringProtocol {
        self = []
        for chunk in hexString.lazy.filter({ !$0.isWhitespace }).chunks(ofCount: 2) {
            guard let high = chunk.first?.strictHexDigitValue,
                  let low = chunk.dropFirst().first?.strictHexDigitValue else {
                return nil
            }
            self.append(.init(nibbles: (high, low)))
        }
    }
}

extension Sequence where Element == UInt8 {
    public func hexString() -> String {
        .init(self.lazy.map(\.nibbles).flatMap({ [$0.high.hexDigit, $0.low.hexDigit] }))
    }
}

@propertyWrapper
public struct HexString: Decodable {
    public let wrappedValue: [UInt8]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let wrappedValue = [UInt8](hexString: try container.decode(String.self)) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "TODO"
            )
        }
        self.wrappedValue = wrappedValue
    }
}
