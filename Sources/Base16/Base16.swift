import BaseDigits

public 
enum Base16 
{
    @inlinable public static 
    func decode<ASCII, Bytes>(_ ascii:ASCII, to _:Bytes.Type = Bytes.self) -> Bytes
        where   Bytes:RangeReplaceableCollection, Bytes.Element == UInt8,
                ASCII:StringProtocol
    {
        self.decode(ascii.utf8, to: Bytes.self)
    }
    @inlinable public static 
    func decode<ASCII, Bytes>(_ ascii:ASCII, to _:Bytes.Type = Bytes.self) -> Bytes
        where   Bytes:RangeReplaceableCollection, Bytes.Element == UInt8,
                ASCII:Sequence, ASCII.Element == UInt8
    {
        var bytes:Bytes = .init()
            bytes.reserveCapacity(ascii.underestimatedCount / 2)
        var ascii:ASCII.Iterator = ascii.makeIterator()
        while   let first:UInt8 = ascii.next(), 
                let second:UInt8 = ascii.next()
        {
            bytes.append(Values[first] << 4 | Values[second])
        }
        return bytes
    }

    @inlinable public static 
    func encode<Bytes, Digits>(_ bytes:Bytes, with _:Digits.Type) -> String
        where Bytes:Sequence, Bytes.Element == UInt8, Digits:BaseDigits
    {
        var encoded:String = ""
            encoded.reserveCapacity(bytes.underestimatedCount * 2)
        for byte:UInt8 in bytes
        {
            encoded.append(Digits[byte >> 4])
            encoded.append(Digits[byte & 0x0f])
        }
        return encoded
    }
}
extension Base16
{
    @inlinable public static 
    func decode<ASCII>(_ ascii:ASCII,
        into bytes:UnsafeMutableRawBufferPointer) -> Void?
        where ASCII:Sequence, ASCII.Element == UInt8
    {
        var ascii:ASCII.Iterator = ascii.makeIterator()
        for offset:Int in bytes.indices
        {
            if  let first:UInt8 = ascii.next(), 
                let second:UInt8 = ascii.next()
            {
                bytes[offset] = Values[first] << 4 | Values[second]
            }
            else 
            {
                return nil 
            }
        }
        return ()
    }
    @inlinable public static
    func encode<BigEndian, Digits>(storing words:BigEndian,
        into ascii:UnsafeMutableRawBufferPointer,
        with _:Digits.Type)
        where Digits:BaseDigits
    {
        withUnsafeBytes(of: words)
        {
            assert(2 * $0.count <= ascii.count)
            
            var offset:Int = ascii.startIndex
            for byte:UInt8 in $0 
            {
                ascii[offset] = Digits[byte >> 4]
                ascii.formIndex(after: &offset)
                ascii[offset] = Digits[byte & 0x0f]
                ascii.formIndex(after: &offset)
            }
        }
    }
}
extension Base16
{    
    #if swift(>=5.6)
    @inlinable public static 
    func decode<ASCII, BigEndian>(_ ascii:ASCII,
        loading _:BigEndian.Type = BigEndian.self) -> BigEndian? 
        where ASCII:Sequence, ASCII.Element == UInt8
    {
        withUnsafeTemporaryAllocation(
            byteCount: MemoryLayout<BigEndian>.size, 
            alignment: MemoryLayout<BigEndian>.alignment)
        {
            let words:UnsafeMutableRawBufferPointer = $0
            if case _? = Self.decode(ascii, into: words)
            {
                return $0.load(as: BigEndian.self)
            }
            else 
            {
                return nil
            }
        }
    }
    #else 
    @available(*, unavailable) public static 
    func decode<ASCII, BigEndian>(_ ascii:ASCII,
        loading _:BigEndian.Type = BigEndian.self) -> BigEndian? 
        where ASCII:Sequence, ASCII.Element == UInt8
    {
        fatalError()
    }
    #endif

    
    @inlinable public static 
    func encode<BigEndian, Digits>(storing words:BigEndian,
        with _:Digits.Type) -> String
        where Digits:BaseDigits
    {
        let bytes:Int = 2 * MemoryLayout<BigEndian>.size
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) 
        if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 14.0, *)
        {
            return try .init(unsafeUninitializedCapacity: bytes)
            {
                Self.encode(storing: words,
                    into: UnsafeMutableRawBufferPointer.init($0),
                    with: Digits.self)
                return bytes
            }
        }
        else 
        {
            return .init(
                decoding: try Self.encode(storing: words, to: [UInt8].self, with: Digits.self), 
                as: Unicode.UTF8.self)
        }
        #elseif swift(>=5.4)
        return .init(unsafeUninitializedCapacity: bytes)
        {
            Self.encode(storing: words,
                into: UnsafeMutableRawBufferPointer.init($0),
                with: Digits.self)
            return bytes
        }
        #else 
        return .init(
            decoding: try Self.encode(storing: words, to: [UInt8].self, with: Digits.self), 
            as: Unicode.UTF8.self)
        #endif 
    }
    
    @inlinable public static 
    func encode<BigEndian, Digits>(storing words:BigEndian, to _:[UInt8].Type,
        with _:Digits.Type) -> [UInt8]
        where Digits:BaseDigits
    {
        let bytes:Int = 2 * MemoryLayout<BigEndian>.size
        return .init(unsafeUninitializedCapacity: bytes)
        {
            Self.encode(storing: words,
                into: UnsafeMutableRawBufferPointer.init($0),
                with: Digits.self)
            $1 = bytes
        }
    }
}
