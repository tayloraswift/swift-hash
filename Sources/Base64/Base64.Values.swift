extension Base64
{
    public
    enum Values
    {
        public static
        let table:[UInt8] =
        [
            //                                     0x2B:
                                                        62, 00, 00, 00, 63,
            52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 00, 00, 00, 00, 00, 00,
            00, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 00, 00, 00, 00, 00,
            00, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
        ]
    }
}
extension Base64.Values
{
    @inlinable public static 
    subscript(codepoint:UInt8) -> UInt8
    {
        0x2B ... 0x7A ~= codepoint ? Self.table[Int.init(codepoint - 0x2B)] : 0
    }
}
