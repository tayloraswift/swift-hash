import Base16

/// The value of a [CRC32](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) checksum.
@frozen public
struct CRC32:Hashable, Sendable
{
    @_documentation(visibility: internal)
    public static
    let table:[UInt32] = (0 ..< 256).map
    {
        (i:UInt32) in
        (0 ..< 8).reduce(i){ (c, _) in (c & 1 * 0xed_b8_83_20) ^ c >> 1 }
    }

    /// The checksum value as a 32-bit unsigned integer.
    public
    var checksum:UInt32

    /// Creates a new checksum with the specified value.
    @inlinable public
    init(checksum:UInt32 = 0)
    {
        self.checksum = checksum
    }

    /// Computes the checksum of the provided message.
    @inlinable public
    init(hashing message:borrowing some Sequence<UInt8>)
    {
        self.init()
        self.update(with: message)
    }

    /// Returns a new checksum by hashing the provided message into the current checksum.
    @inlinable public consuming
    func updated(with message:borrowing some Sequence<UInt8>) -> Self
    {
        var checksum:Self = self
        checksum.update(with: message)
        return checksum
    }

    /// Returns a new checksum by hashing the provided message into the current checksum.
    ///
    /// This manually specialized implementation is much faster in debug mode than the
    /// generic implementation, but exactly the same in release mode.
    @inlinable public consuming
    func _updated(with message:borrowing [UInt8]) -> Self
    {
        var checksum:Self = self
        checksum._update(with: message)
        return checksum
    }

    /// Updates the checksum by hashing the provided message into the existing checksum.
    @inlinable public mutating
    func update(with message:borrowing some Sequence<UInt8>)
    {
        self.checksum = ~message.reduce(~self.checksum)
        {
            (state:UInt32, byte:UInt8) in
            let indexByte:UInt8 = UInt8.init(truncatingIfNeeded: state) ^ byte
            let index:Int = Int.init(indexByte)
            return Self.table[index] ^ state >> 8
        }
    }

    /// Updates the checksum by hashing the provided message into the existing checksum.
    ///
    /// This manually specialized implementation is much faster in debug mode than the
    /// generic implementation, but exactly the same in release mode.
    @inlinable public mutating
    func _update(with message:borrowing [UInt8])
    {
        #if DEBUG
            // in debug mode this manually specialized version of `reduce` is about 2.8x faster
            self.checksum = ~self.checksum
            var i:Int = 0
            while i < message.count
            {
                let state:UInt32 = self.checksum
                let byte:UInt8 = message[i]
                let indexByte:UInt8 = UInt8.init(truncatingIfNeeded: state) ^ byte
                let index:Int
                // in debug mode these hacky integer conversions make this function
                // around 35% faster
                if MemoryLayout<Int>.stride == 8 {
                    let tuple:(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) =
                    (
                        indexByte, 0, 0, 0, 0, 0, 0, 0
                    )
                    index = unsafeBitCast(tuple, to: Int.self)
                } else {
                    let tuple:(UInt8, UInt8, UInt8, UInt8) =
                    (
                        indexByte, 0, 0, 0
                    )
                    index = unsafeBitCast(tuple, to: Int.self)
                }
                self.checksum = Self.table[index] ^ state >> 8
                i += 1
            }
            self.checksum = ~self.checksum
        #else
            self.update(with: message[...])
        #endif
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
    /// The lowercased hexadecimal representation of the checksum value.
    @inlinable public
    var description:String
    {
        Base16.encode(storing: self.checksum.bigEndian, with: Base16.LowercaseDigits.self)
    }
}
