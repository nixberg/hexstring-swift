import Algorithms

@propertyWrapper
public struct HexString: Decodable, ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public let wrappedValue: [UInt8]
    
    public init(stringLiteral hexString: StringLiteralType) {
        let hexString = hexString.filter { !$0.isWhitespace }
        
        precondition(hexString.count.isMultiple(of: 2))
        
        wrappedValue = hexString
            .chunks(ofCount: 2)
            .compactMap { UInt8($0, radix: 16) }
        
        precondition(wrappedValue.count == hexString.count / 2)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self).filter { !$0.isWhitespace }
        
        guard hexString.count.isMultiple(of: 2) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
        
        wrappedValue = hexString.chunks(ofCount: 2).compactMap {
            UInt8($0, radix: 16)
        }
        
        guard wrappedValue.count == hexString.count / 2 else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
    }
}
