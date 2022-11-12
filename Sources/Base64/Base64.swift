import BaseDigits

public
enum Base64 
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
        // https://en.wikipedia.org/wiki/Base64
        var input:Input<ASCII> = .init(ascii),
            bytes:Bytes = .init()
            bytes.reserveCapacity(ascii.underestimatedCount * 3 / 4)
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
    func encode<Bytes>(_ bytes:Bytes) -> String where Bytes:Sequence, Bytes.Element == UInt8
    {
        var encoded:String = ""
            encoded.reserveCapacity(bytes.underestimatedCount * 4 / 3)
        var bytes:Bytes.Iterator = bytes.makeIterator()
        while let first:UInt8   = bytes.next()
        {
            encoded.append(    Digits[first  >> 2])

            guard let second:UInt8 = bytes.next() 
            else 
            {
                encoded.append(Digits[first  << 4])
                encoded.append("=")
                encoded.append("=")
                continue 
            }
            
            encoded.append(    Digits[first  << 4 | second >> 4])

            guard let third:UInt8 = bytes.next() 
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
