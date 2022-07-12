import Base16
import SHA2

enum TestFailureError:Error 
{
    case hmac256(SHA256, expected:SHA256, message:[UInt8], key:[UInt8])
}
@main 
struct Tests 
{
    typealias Case = (key:String, message:String, hmac256:SHA256)

    static 
    func main() throws
    {
        for (i, (key, message, expected)):(Int, (String, String, SHA256)) in 
            Self.cases.enumerated()
        {            
            let key:[UInt8] = Base16.decode(utf8: key.utf8)!
            let message:[UInt8] = Base16.decode(utf8: message.utf8)!
            
            let computed:SHA256 = .hmac(message, key: key)
            if  computed == expected
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
