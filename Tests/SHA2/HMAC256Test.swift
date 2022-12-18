import Base16
import SHA2
import Testing

struct MessageAuthenticationTest
{
    let name:String
    let key:String,
        message:String,
        expected:SHA256

    init(name:String, key:String, message:String, hmac256 expected:SHA256)
    {
        self.name = name
        self.key = key
        self.message = message
        self.expected = expected
    }
}
extension MessageAuthenticationTest:SyncTestCase
{
    func run(tests:inout Tests)
    {            
        let key:[UInt8] = Base16.decode(self.key.utf8)
        let message:[UInt8] = Base16.decode(self.message.utf8)
        
        let computed:SHA256 = .init(authenticating: message, key: key)
        tests.assert(computed ==? self.expected, name: "hmacs-equal")
    }
}
