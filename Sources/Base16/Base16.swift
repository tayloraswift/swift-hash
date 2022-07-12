public 
enum Base16 
{
    @inlinable public static 
    func ascii(lowercasing value:UInt8) -> UInt8
    {
        (value < 10 ? 0x30 : 0x61 - 10) &+ value
    }
    @inlinable public static 
    func ascii(uppercasing value:UInt8) -> UInt8
    {
        (value < 10 ? 0x30 : 0x41 - 10) &+ value
    }
    @inlinable public static 
    func value(ascii digit:UInt8) -> UInt8?
    {
        switch digit 
        {
        case 0x30 ... 0x39: return digit      - 0x30
        case 0x61 ... 0x66: return digit + 10 - 0x61
        case 0x41 ... 0x46: return digit + 10 - 0x41
        default:            return nil
        }
    }
    
    @inlinable public static 
    func decode<UTF8, Bytes>(utf8:UTF8, as _:Bytes.Type = Bytes.self) -> Bytes?
        where   UTF8:Sequence, UTF8.Element == UInt8, 
                Bytes:RangeReplaceableCollection, Bytes.Element == UInt8
    {
        var bytes:Bytes = .init()
        var utf8:UTF8.Iterator = utf8.makeIterator()
        while   let first:UInt8 = utf8.next(), 
                let second:UInt8 = utf8.next()
        {
            if  let high:UInt8 = Self.value(ascii: first),
                let low:UInt8 = Self.value(ascii: second)
            {
                bytes.append(high << 4 | low)
            }
            else 
            {
                return nil 
            }
        }
        return bytes
    }
    
    #if swift(>=5.6)
    @inlinable public static 
    func decodeBigEndian<UTF8, Words>(utf8:UTF8, as _:Words.Type = Words.self) -> Words? 
        where UTF8:Sequence, UTF8.Element == UInt8
    {
        withUnsafeTemporaryAllocation(
            byteCount: MemoryLayout<Words>.size, 
            alignment: MemoryLayout<Words>.alignment)
        {
            var words:UnsafeMutableRawBufferPointer = $0
            if case _? = Self.decodeBigEndian(utf8: utf8, words: &words)
            {
                return $0.load(as: Words.self)
            }
            else 
            {
                return nil
            }
        }
    }
    #else 
    @available(*, unavailable) public static 
    func decodeBigEndian<UTF8, Words>(utf8:UTF8, as _:Words.Type = Words.self) -> Words? 
        where UTF8:Sequence, UTF8.Element == UInt8
    {
        fatalError()
    }
    #endif
    @inlinable public static 
    func decodeBigEndian<UTF8, Words>(utf8:UTF8, words:inout Words) -> Void? 
        where   UTF8:Sequence, UTF8.Element == UInt8, 
                Words:MutableCollection, Words.Element == UInt8
    {
        var utf8:UTF8.Iterator = utf8.makeIterator()
        for offset:Words.Index in words.indices 
        {
            if  let first:UInt8 = utf8.next(), 
                let second:UInt8 = utf8.next(), 
                let high:UInt8 = Self.value(ascii: first),
                let low:UInt8 = Self.value(ascii: second)
            {
                words[offset] = high << 4 | low
            }
            else 
            {
                return nil 
            }
        }
        return ()
    }
    
    @inlinable public static 
    func encodeBigEndian<Words>(_ words:Words, as _:String.Type = String.self, 
        by ascii:(UInt8) throws -> UInt8) rethrows -> String
    {
        #if os(macOS)
        if #available(macOS 11.0, *)
        {
            return try .init(unsafeUninitializedCapacity: 2 * MemoryLayout<Words>.size)
            {
                var utf8:UnsafeMutableBufferPointer<UInt8> = $0
                try Self.encodeBigEndian(words, utf8: &utf8, by: ascii)
                return $0.count
            }
        }
        else 
        {
            return .init(decoding: try Self.encodeBigEndian(words, as: [UInt8].self, by: ascii), 
                as: Unicode.UTF8.self)
        }
        #elseif swift(>=5.4)
        try .init(unsafeUninitializedCapacity: 2 * MemoryLayout<Words>.size)
        {
            var utf8:UnsafeMutableBufferPointer<UInt8> = $0
            try Self.encodeBigEndian(words, utf8: &utf8, by: ascii)
            return $0.count
        }
        #else 
        return .init(decoding: try Self.encodeBigEndian(words, as: [UInt8].self, by: ascii), 
            as: Unicode.UTF8.self)
        #endif 
    }
    
    @inlinable public static 
    func encodeBigEndian<Words>(lowercasing words:Words, as _:String.Type = String.self) 
        -> String
    {
        Self.encodeBigEndian(words, by: Self.ascii(lowercasing:))
    }
    @inlinable public static 
    func encodeBigEndian<Words>(uppercasing words:Words, as _:String.Type = String.self) 
        -> String
    {
        Self.encodeBigEndian(words, by: Self.ascii(uppercasing:))
    }
    
    @inlinable public static 
    func encodeBigEndian<Words>(lowercasing words:Words, as _:[UInt8].Type = [UInt8].self) 
        -> [UInt8]
    {
        Self.encodeBigEndian(words, by: Self.ascii(lowercasing:))
    }
    @inlinable public static 
    func encodeBigEndian<Words>(uppercasing words:Words, as _:[UInt8].Type = [UInt8].self) 
        -> [UInt8]
    {
        Self.encodeBigEndian(words, by: Self.ascii(uppercasing:))
    }
    @inlinable public static 
    func encodeBigEndian<Words>(_ words:Words, as _:[UInt8].Type = [UInt8].self, 
        by ascii:(UInt8) throws -> UInt8) rethrows -> [UInt8]
    {
        try .init(unsafeUninitializedCapacity: 2 * MemoryLayout<Words>.size)
        {
            try Self.encodeBigEndian(words, utf8: &$0, by: ascii)
            $1 = $0.count
        }
    }
    
    @inlinable public static 
    func encodeBigEndian<UTF8, Words>(lowercasing words:Words, utf8:inout UTF8)
        where UTF8:MutableCollection, UTF8.Element == UInt8
    {
        Self.encodeBigEndian(words, utf8: &utf8, by: Self.ascii(lowercasing:))
    }
    @inlinable public static 
    func encodeBigEndian<UTF8, Words>(uppercasing words:Words, utf8:inout UTF8)
        where UTF8:MutableCollection, UTF8.Element == UInt8
    {
        Self.encodeBigEndian(words, utf8: &utf8, by: Self.ascii(uppercasing:))
    }
    @inlinable public static 
    func encodeBigEndian<UTF8, Words>(_ words:Words, utf8:inout UTF8, 
        by ascii:(UInt8) throws -> UInt8) rethrows
        where UTF8:MutableCollection, UTF8.Element == UInt8
    {
        try withUnsafeBytes(of: words)
        {
            assert(utf8.count == $0.count * 2)
            
            var offset:UTF8.Index = utf8.startIndex
            for byte:UInt8 in $0 
            {
                utf8[offset] = try ascii(byte >> 4)
                utf8.formIndex(after: &offset)
                utf8[offset] = try ascii(byte & 0x0f)
                utf8.formIndex(after: &offset)
            }
        }
    }
}
