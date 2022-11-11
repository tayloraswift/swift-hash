import Testing
import Base16
import SHA2

extension UnitTests
{
    mutating func
    test(name:String, key:String, message:String, hmac256 expected:SHA256)
    {
        let key:[UInt8] = Base16.decode(key.utf8)
        let message:[UInt8] = Base16.decode(message.utf8)
        
        let computed:SHA256 = .hmac(message, key: key)
        self.assert(computed ==? expected, name: name)
    }
}
