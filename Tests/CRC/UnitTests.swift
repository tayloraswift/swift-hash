import CRC
import Testing

extension UnitTests
{
    mutating
    func test(name:String, message:String, expected:CRC32)
    {            
        let computed:CRC32 = .init(hashing: message.utf8)
        self.assert(computed ==? expected, name: name)
    }
}
