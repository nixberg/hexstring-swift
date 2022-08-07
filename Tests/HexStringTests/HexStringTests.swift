import HexString
import XCTest

final class HexStringTests: XCTestCase {
    func testArrayInit() {
        let expected: [UInt8] = [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]
        XCTAssertEqual([UInt8](hexString: "0123456789abcdef"), expected)
        XCTAssertEqual([UInt8](hexString: "0123456789ABCDEF"), expected)
        XCTAssertEqual([UInt8](hexString: " 01234\t56789\nab  cdef"), expected)
        
        XCTAssertNil([UInt8](hexString: "0x0123456789abcdef"))
        XCTAssertNil([UInt8](hexString: "01:23:45:67:89:ab:cd:ef"))
    }
    
    func testArrayHexString() {
        XCTAssertEqual(
            [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef].hexString(),
            "0123456789abcdef"
        )
    }
    
    func testRandomArrayRoundtrips() {
        for _ in 0..<1024 {
            var rng = SystemRandomNumberGenerator()
            let expected: [UInt8] = (0..<Int.random(in: 0...128)).map({ _ in rng.next() })
            XCTAssertEqual(Array(hexString: expected.hexString()), expected)
        }
    }
    
    func testDecodable() throws {
        struct Struct: Decodable {
            @HexString var bytes: [UInt8]
        }
        XCTAssertEqual(try JSONDecoder().decode(
            Struct.self,
            from: #"{"bytes": "0123456789abcdef"}"#.data(using: .ascii)!
        ).bytes, [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
    }
}
