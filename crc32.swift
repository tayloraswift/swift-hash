struct CRC32:Hashable, ExpressibleByIntegerLiteral
{
    private static 
    let table:[UInt32] = (0 ..< 256).map 
    {
        (i:UInt32) in 
        (0 ..< 8).reduce(i){ (c, _) in (c & 1 * 0xed_b8_83_20) ^ c >> 1 }
    }
    
    private(set)
    var checksum:UInt32 
    
    init(to checksum:UInt32 = 0)
    {
        self.checksum = checksum 
    }
    init(integerLiteral checksum:UInt32)
    {
        self.init(to: checksum)
    }
    
    mutating 
    func update<S>(with input:S)  
        where S:Sequence, S.Element == UInt8 
    {
        self.checksum = ~input.reduce(~self.checksum) 
        {
            (state:UInt32, byte:UInt8) in 
            Self.table[.init((.init(truncatingIfNeeded: state) ^ byte))] ^ state >> 8
        }
    }
    func updated<S>(with input:S) -> Self  
        where S:Sequence, S.Element == UInt8 
    {
        var checksum:Self = self 
        checksum.update(with: input)
        return checksum
    }
    
    init<S>(for input:S)
        where S:Sequence, S.Element == UInt8 
    {
        self.init(to: 0)
        self.update(with: input)
    }
}
extension CRC32:CustomStringConvertible 
{
    var description:String 
    {
        "crc32:\(Base16.encode(self.checksum, as: String.self))"
    }
}
