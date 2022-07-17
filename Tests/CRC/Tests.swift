import Base16
import CRC

enum TestFailureError:Error 
{
    case crc32(CRC32, expected:CRC32, message:[UInt8])
}
@main 
struct Tests 
{
    typealias Case = (message:[UInt8], crc32:CRC32)

    static 
    func main() throws
    {
        for (i, (message, expected)):(Int, ([UInt8], CRC32)) in 
            Self.cases.enumerated()
        {            
            let computed:CRC32 = .init(hashing: message)
            if  computed == expected
            {
                print("passed crc32 test \(i) of \(Self.cases.count)")
            }
            else 
            {
                throw TestFailureError.crc32(computed, 
                    expected: expected,
                    message: message)
            }
        }
        
        print("all tests passed!")
    }
}
