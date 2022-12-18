import Base64
import Testing

struct Base64Test
{
    let name:String
    let degenerate:String?
    let canonical:String
    let expected:[UInt8]

    init(name:String,
        degenerate:String? = nil,
        canonical:String, 
        expected:[UInt8])
    {
        self.name = name
        self.degenerate = degenerate
        self.canonical = canonical
        self.expected = expected
    }
}
extension Base64Test
{
    init<UTF8>(name:String,
        degenerate:String? = nil,
        canonical:String, 
        expected:UTF8) where UTF8:Collection, UTF8.Element == UInt8
    {
        self.init(name: name,
            degenerate: degenerate,
            canonical: canonical,
            expected: .init(expected))
    }
    init(name:String,
        degenerate:String? = nil,
        canonical:String, 
        expected:String)
    {
        self.init(name: name,
            degenerate: degenerate,
            canonical: canonical,
            expected: expected.utf8)
    }
}
extension Base64Test:SyncTestCase
{
    func run(tests:inout Tests)
    {
        tests.assert(Base64.decode(self.canonical.utf8, to: [UInt8].self) ..? self.expected,
            name: "decode-canonical")
        tests.assert(Base64.encode(self.expected) ..? self.canonical,
            name: "encode")

        if let degenerate:String = self.degenerate
        {
            let decoded:[UInt8] = Base64.decode(degenerate, to: [UInt8].self)
            let encoded:String = Base64.encode(decoded)
            tests.assert(decoded ..? self.expected,
                name: "decode-degenerate")
            tests.assert(encoded ..? self.canonical,
                name: "reencode")
        }
    }
}
extension Base64Test:SyncTestEnvironment
{
}