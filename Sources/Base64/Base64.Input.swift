extension Base64 
{
    /// An abstraction over text input, which discards the ASCII whitespace
    /// characters [`'\t'`](), [`'\n'`](), [`'\f'`](), [`'\r'`](), and [`' '`]().
    ///
    /// Iteration over an instance of this type will halt upon encountering the
    /// first [`'='`]() padding character, even if the underlying sequence contains
    /// more characters.
    @frozen public
    struct Input<ASCII> where ASCII:Sequence, ASCII.Element == UInt8
    {
        public
        var iterator:ASCII.Iterator

        @inlinable public
        init(_ ascii:ASCII)
        {
            self.iterator = ascii.makeIterator()
        }
    }
}
extension Base64.Input:Sequence, IteratorProtocol
{
    public
    typealias Iterator = Self

    @inlinable public mutating
    func next() -> UInt8?
    {
        while let byte:UInt8 = self.iterator.next(), byte != 0x3D // '='
        {
            if  byte != 0x09, // '\t'
                byte != 0x0A, // '\n'
                byte != 0x0C, // '\f'
                byte != 0x0D, // '\r'
                byte != 0x20  // ' '
            {
                return byte
            }
        }
        return nil
    }
}
