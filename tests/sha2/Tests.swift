import SHA2

enum TestFailureError:Error 
{
    case hmac256(SHA256, expected:[UInt8], message:[UInt8], key:[UInt8])
}
@main 
struct Tests 
{
    typealias Case = (key:String, message:String, hmac256:String)
    
    private static 
    func bytes(hex:String) -> [UInt8]
    {
        var bytes:[UInt8] = []
        var start:String.Index = hex.startIndex 
        while let end:String.Index = 
            hex.index(start, offsetBy: 2, limitedBy: hex.endIndex)
        {
            bytes.append(UInt8.init(hex[start ..< end], radix: 16)!)
            start = end 
        }
        return bytes
    }

    static 
    func main() throws
    {
        for (i, (key, message, hmac256)):(Int, (String, String, String)) in 
            Self.cases.enumerated()
        {
            let key:[UInt8] = Self.bytes(hex: key)
            let message:[UInt8] = Self.bytes(hex: message)
            let expected:[UInt8] = Self.bytes(hex: hmac256)
            let computed:SHA256 = .hmac(message, key: key)
            
            if computed.starts(with: expected)
            {
                print("passed hmac-sha256 test \(i) of \(Self.cases.count)")
            }
            else 
            {
                throw TestFailureError.hmac256(computed, 
                    expected: expected,
                    message: message,
                    key: key)
            }
        }
        
        print("all tests passed!")
    }
}
