import Base64
import Testing

extension UnitTests
{
    mutating
    func test(name:String,
        degenerate:String? = nil,
        canonical:String, 
        expected:String)
    {
        self.test(name: name, degenerate: degenerate, canonical: canonical,
            expected: expected.utf8)
    }
    mutating
    func test<Bytes>(name:String,
        degenerate:String? = nil,
        canonical:String, 
        expected:Bytes)
        where Bytes:Collection, Bytes.Element == UInt8
    {
        self.assert(Base64.decode(canonical.utf8) ..? expected,
            name: "decode-canonical")
        self.assert(Base64.encode(expected) ==? canonical,
            name: "encode")

        if let degenerate:String = degenerate
        {
            let decoded:[UInt8] = Base64.decode(degenerate.utf8)
            let encoded:String = Base64.encode(decoded)
            self.assert(decoded ..? expected,
                name: "decode-degenerate")
            self.assert(encoded == canonical,
                name: "reencode")
        }
    }
}
