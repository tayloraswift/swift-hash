import Base16

@frozen public
struct CRC32:Hashable, Sendable
{
    public static
    let table:[UInt32] = (0 ..< 256).map
    {
        (i:UInt32) in
        (0 ..< 8).reduce(i){ (c, _) in (c & 1 * 0xed_b8_83_20) ^ c >> 1 }
    }

    public
    var checksum:UInt32

    @inlinable public
    init(checksum:UInt32 = 0)
    {
        self.checksum = checksum
    }
    @inlinable public
    init(hashing message:some Sequence<UInt8>)
    {
        self.init()
        self.update(with: message)
    }

    @inlinable public
    func updated(with message:some Sequence<UInt8>) -> Self
    {
        var checksum:Self = self
        checksum.update(with: message)
        return checksum
    }
    @inlinable public mutating
    func update(with message:some Sequence<UInt8>)
    {
        self.checksum = ~message.reduce(~self.checksum)
        {
            (state:UInt32, byte:UInt8) in
            Self.table[Int.init(UInt8.init(truncatingIfNeeded: state) ^ byte)] ^ state >> 8
        }
    }
}
extension CRC32:ExpressibleByIntegerLiteral
{
    @inlinable public
    init(integerLiteral:UInt32)
    {
        self.init(checksum: integerLiteral)
    }
}
extension CRC32:CustomStringConvertible
{
    @inlinable public
    var description:String
    {
        Base16.encode(storing: self.checksum.bigEndian, with: Base16.LowercaseDigits.self)
    }
}
