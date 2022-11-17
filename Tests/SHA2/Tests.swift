import Base16
import SHA2
import Testing

extension Tests
{
    mutating
    func test(name:String, key:String, message:String, hmac256 expected:SHA256)
    {
        let key:[UInt8] = Base16.decode(key.utf8)
        let message:[UInt8] = Base16.decode(message.utf8)
        
        let computed:SHA256 = .init(authenticating: message, key: key)
        self.assert(computed ==? expected, name: name)
    }
    mutating
    func test(name:String, password:String, salt:String, iterations:Int, derived:[UInt8])
    {
        let (quotient, remainder):(Int, Int) = derived.count.quotientAndRemainder(
            dividingBy: SHA256.count)
        let key:[UInt8] = SHA256.pbkdf2(password: password.utf8, salt: salt.utf8,
            iterations: iterations,
            blocks: quotient + max(remainder, 1))
        
        self.assert(key.prefix(derived.count) ..? derived, name: name)
    }
}
