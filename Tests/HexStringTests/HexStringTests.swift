import HexString
import XCTest

final class HexStringTests: XCTestCase {
    func testDecodable() throws {
        struct Struct: Decodable {
            @HexString var bytes: [UInt8]
        }
        
        let decoded = try JSONDecoder()
            .decode(Struct.self, from: """
            {
                "bytes": "dead      b eef"
            }
            """.data(using: .ascii)!)
        
        XCTAssertEqual(decoded.bytes, [0xde, 0xad, 0xbe, 0xef])
        
        XCTAssertThrowsError(try JSONDecoder()
                                .decode(Struct.self, from: """
                                {
                                    "bytes": "de:ad      b eef"
                                }
                                """.data(using: .ascii)!))
        
        XCTAssertThrowsError(try JSONDecoder()
                                .decode(Struct.self, from: """
                                {
                                    "bytes": "dead      b ee"
                                }
                                """.data(using: .ascii)!))
    }
    
    func testExpressibleByStringLiteral() {
        let bytes: [UInt8] = "dead      b eef"
        XCTAssertEqual(bytes, [0xde, 0xad, 0xbe, 0xef])
    }
}
