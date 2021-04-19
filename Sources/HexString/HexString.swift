import Algorithms
import Foundation

public struct HexString: Decodable {
    private let bytes: [UInt8]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        
        guard hexString.count.isMultiple(of: 2) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
        
        guard hexString.allSatisfy(\.isHexDigit) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
        
        bytes = hexString.chunks(ofCount: 2).compactMap {
            UInt8($0, radix: 16)
        }
    }
}

extension HexString: Sequence {
    public typealias Element = Array<UInt8>.Element
    
    public typealias Iterator = Array<UInt8>.Iterator
    
    @inline(__always)
    public func makeIterator() -> Self.Iterator {
        bytes.makeIterator()
    }
    
    @inline(__always)
    public var underestimatedCount: Int {
        bytes.underestimatedCount
    }
    
    @inline(__always)
    public func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<Self.Element>
    ) throws -> R) rethrows -> R? {
        try bytes.withContiguousStorageIfAvailable(body)
    }
}

extension HexString: Collection {
    public typealias Index = Array<UInt8>.Index
    
    public typealias Indices = Array<UInt8>.Indices
    
    public typealias SubSequence = Array<UInt8>.SubSequence
    
    @inline(__always)
    public subscript(position: Self.Index) -> Self.Element {
        bytes[position]
    }
    
    @inline(__always)
    public var startIndex: Self.Index {
        bytes.startIndex
    }
    
    @inline(__always)
    public var endIndex: Self.Index {
        bytes.endIndex
    }
    
    @inline(__always)
    public var indices: Self.Indices {
        bytes.indices
    }
    
    @inline(__always)
    public func index(after i: Self.Index) -> Self.Index {
        bytes.index(after: i)
    }
    
    @inline(__always)
    public var count: Int {
        bytes.count
    }
    
    @inline(__always)
    public var isEmpty: Bool {
        bytes.isEmpty
    }
    
    @inline(__always)
    public func distance(from start: Self.Index, to end: Self.Index) -> Int {
        bytes.distance(from: start, to: end)
    }
    
    @inline(__always)
    public func formIndex(after i: inout Self.Index) {
        bytes.formIndex(after: &i)
    }
    
    @inline(__always)
    public func index(_ i: Self.Index, offsetBy distance: Int) -> Self.Index {
        bytes.index(i, offsetBy: distance)
    }
    
    @inline(__always)
    public func index(_ i: Self.Index, offsetBy distance: Int, limitedBy limit: Self.Index)
    -> Self.Index? {
        bytes.index(i, offsetBy: distance, limitedBy: limit)
    }
    
    @inline(__always)
    public subscript(bounds: Range<Self.Index>) -> Self.SubSequence {
        bytes[bounds]
    }
}

extension HexString: BidirectionalCollection {
    @inline(__always)
    public func index(before i: Self.Index) -> Self.Index {
        bytes.index(before: i)
    }
}

extension HexString: RandomAccessCollection { }

extension HexString: DataProtocol {
    public typealias Regions = Array<UInt8>.Regions
    
    @inline(__always)
    public var regions: Self.Regions {
        bytes.regions
    }
}
