extension Base64 
{
    /// An abstraction over text input, which discards ASCII whitespace
    /// characters.
    @frozen public
    struct Input<UTF8> where UTF8:Sequence, UTF8.Element == UInt8
    {
        public
        var iterator:UTF8.Iterator

        @inlinable public
        init(_ utf8:UTF8)
        {
            self.iterator = utf8.makeIterator()
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
