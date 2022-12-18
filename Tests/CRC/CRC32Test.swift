import CRC
import Testing

struct CRC32Test
{
    let name:String
    let message:String
    let expected:CRC32

    init(name:String,
        message:String,
        expected:CRC32)
    {
        self.name = name
        self.message = message
        self.expected = expected
    }
}
extension CRC32Test:SyncTestCase
{
    func run(tests:inout Tests)
    {            
        let computed:CRC32 = .init(hashing: self.message.utf8)
        tests.assert(computed ==? self.expected, name: "checksums-equal")
    }
}
extension CRC32Test:SyncTestEnvironment
{
}
