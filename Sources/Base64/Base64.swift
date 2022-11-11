public
enum Base64 
{
    @inlinable public static 
    func decode<Encoded>(_ utf8:Encoded) -> [UInt8]
        where Encoded:Sequence, Encoded.Element == UInt8
    {
        // https://en.wikipedia.org/wiki/Base64
        var input:Input<Encoded> = .init(utf8),
            bytes:[UInt8] = []
            bytes.reserveCapacity(utf8.underestimatedCount * 3 / 4)
        while   let first:UInt8 = input.next(),
                let second:UInt8 = input.next()
        {
            bytes.append(Values[first] << 2 | Values[second] >> 4)

            guard let third:UInt8 = input.next()
            else
            {
                break
            }

            bytes.append(Values[second] << 4 | Values[third] >> 2)

            guard let fourth:UInt8 = input.next()
            else
            {
                break
            }

            bytes.append(Values[third] << 6 | Values[fourth])
        }
        return bytes
    }

    @inlinable public static 
    func encode<S>(_ bytes:S) -> String where S:Sequence, S.Element == UInt8
    {
        var iterator:S.Iterator = bytes.makeIterator(), 
            encoded:String      = ""
        while let first:UInt8   = iterator.next() 
        {
            encoded.append(    Digits[first  >> 2])

            guard let second:UInt8 = iterator.next() 
            else 
            {
                encoded.append(Digits[first  << 4])
                encoded.append("=")
                encoded.append("=")
                continue 
            }
            
            encoded.append(    Digits[first  << 4 | second >> 4])

            guard let third:UInt8 = iterator.next() 
            else 
            {
                encoded.append(Digits[second << 2])
                encoded.append("=")
                continue 
            }
            
            encoded.append(    Digits[second << 2 | third  >> 6])
            encoded.append(    Digits[third])
        }
        return encoded 
    }
}
