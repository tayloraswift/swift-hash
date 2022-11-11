extension Base16
{
    public
    enum Values
    {
    }
}
extension Base16.Values
{
    @inlinable public static 
    subscript(digit:UInt8) -> UInt8
    {
        switch digit 
        {
        case 0x30 ... 0x39: return digit      - 0x30
        case 0x61 ... 0x66: return digit + 10 - 0x61
        case 0x41 ... 0x46: return digit + 10 - 0x41
        default:            return 0
        }
    }
}
