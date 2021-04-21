import Algorithms

@propertyWrapper
public struct HexString: Decodable {
    public let wrappedValue: [UInt8]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        
        guard hexString.count.isMultiple(of: 2) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
        
        guard hexString.allSatisfy(\.isHexDigit) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
        
        wrappedValue = hexString.chunks(ofCount: 2).compactMap {
            UInt8($0, radix: 16)
        }
    }
}
