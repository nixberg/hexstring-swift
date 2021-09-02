import Algorithms

@propertyWrapper
public struct HexString: Decodable {
    public let wrappedValue: [UInt8]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let strippedHexString = try container.decode(String.self).filter { !$0.isWhitespace }
        
        guard strippedHexString.count.isMultiple(of: 2) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
        
        wrappedValue = strippedHexString
            .chunks(ofCount: 2)
            .compactMap { UInt8($0, radix: 16) }
        
        guard wrappedValue.count == strippedHexString.count / 2 else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
    }
}

extension Array: ExpressibleByStringLiteral where Element == UInt8 {
    public typealias StringLiteralType = String
    
    public init(stringLiteral hexString: StringLiteralType) {
        let strippedHexString = hexString.filter { !$0.isWhitespace }
        
        precondition(strippedHexString.count.isMultiple(of: 2))
        
        self = strippedHexString
            .chunks(ofCount: 2)
            .compactMap { UInt8($0, radix: 16) }
        
        precondition(count == strippedHexString.count / 2)
    }
}

extension Array: ExpressibleByUnicodeScalarLiteral where Element == UInt8 {
    public typealias UnicodeScalarLiteralType = String
}

extension Array: ExpressibleByExtendedGraphemeClusterLiteral where Element == UInt8 {
    public typealias ExtendedGraphemeClusterLiteralType = String
}
