import SHA2
import Testing

struct KeyDerivationTest
{
    let name:String
    let password:String,
        salt:String,
        iterations:Int,
        derived:[UInt8]

    init(name:String, password:String, salt:String, iterations:Int, derived:[UInt8])
    {
        self.name = name
        self.password = password
        self.salt = salt
        self.iterations = iterations
        self.derived = derived
    }
}
extension KeyDerivationTest:SyncTestCase
{
    func run(tests:inout Tests)
    {
        let (quotient, remainder):(Int, Int) = self.derived.count.quotientAndRemainder(
            dividingBy: SHA256.count)
        let key:[UInt8] = SHA256.pbkdf2(password: self.password.utf8, salt: self.salt.utf8,
            iterations: self.iterations,
            blocks: quotient + max(remainder, 1))
        
        tests.assert(key.prefix(self.derived.count) ..? self.derived, name: "keys-equal")
    }
}
