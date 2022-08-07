struct UInt4 {
    fileprivate var value: UInt8
    
    fileprivate init(truncatingIfNeeded source: UInt8) {
        value = source & 0b0000_1111
    }
    
    var hexDigit: Character {
        assert(value & 0b0000_1111 == value)
        if value < 0xa {
            return Character(Unicode.Scalar(value + UInt8(ascii: "0")))
        } else {
            return Character(Unicode.Scalar(value + UInt8(ascii: "a") - 0xa))
        }
    }
}

extension Character {
    var strictHexDigitValue: UInt4? {
        guard let asciiValue = asciiValue else {
            return nil
        }
        switch asciiValue {
        case UInt8(ascii: "0")...UInt8(ascii: "9"):
            return .init(truncatingIfNeeded: asciiValue - UInt8(ascii: "0"))
        case UInt8(ascii: "A")...UInt8(ascii: "F"):
            return .init(truncatingIfNeeded: asciiValue - UInt8(ascii: "A") + 0x0a)
        case UInt8(ascii: "a")...UInt8(ascii: "f"):
            return .init(truncatingIfNeeded: asciiValue - UInt8(ascii: "a") + 0x0a)
        default:
            return nil
        }
    }
}

extension UInt8 {
    init(nibbles: (high: UInt4, low: UInt4)) {
        self = (UInt8(truncatingIfNeeded: nibbles.high) << 4)
        self |= UInt8(truncatingIfNeeded: nibbles.low)
    }
    
    var nibbles: (high: UInt4, low: UInt4) {
        (high: UInt4(truncatingIfNeeded: self >> 4), low: UInt4(truncatingIfNeeded: self))
    }
    
    private init(truncatingIfNeeded source: UInt4) {
        self = source.value
    }
}
