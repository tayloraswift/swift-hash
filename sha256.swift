struct SHA256
{
    private 
    typealias UInt32x8 = (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    
    private static 
    let table:[UInt32] = 
    [
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 
        0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 
        0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    ]
    
    private 
    var h:UInt32x8
    
    var value:[UInt8] 
    {
        var bytes:[UInt8] = []
            bytes.reserveCapacity(32)
        for word:UInt32 in 
        [
            self.h.0,
            self.h.1,
            self.h.2,
            self.h.3,
            self.h.4,
            self.h.5,
            self.h.6,
            self.h.7,
        ]
        {
            withUnsafeBytes(of: word.bigEndian)
            {
                for byte:UInt8 in $0 
                {
                    bytes.append(byte)
                }
            }
        }
        return bytes 
    }
    
    init() 
    {
        self.h = 
        (
            0x6a09e667,
            0xbb67ae85,
            0x3c6ef372,
            0xa54ff53a,
            0x510e527f,
            0x9b05688c,
            0x1f83d9ab,
            0x5be0cd19
        )
    }
    
    init<S>(for input:S)
        where S:Sequence, S.Element == UInt8 
    {
        self.init()
        
        var message:[UInt8] = .init(input)
        let length:UInt64   = .init(message.count << 3)
        
        message.append(0x80)
        while message.count & 63 != 56
        {
            message.append(0x00)
        }
        withUnsafeBytes(of: length.bigEndian)
        {
            for byte:UInt8 in $0 
            {
                message.append(byte)
            }
        }
        
        for start:Int in stride(from: message.startIndex, to: message.endIndex, by: 64)
        {
            self.update(with: message.dropFirst(start).prefix(64))
        }
    } 
    
    private mutating 
    func update(with chunk:ArraySlice<UInt8>) 
    {
        assert(chunk.count == 64)
        
        let schedule:[UInt32] = .init(unsafeUninitializedCapacity: 64)
        {
            (buffer:inout UnsafeMutableBufferPointer<UInt32>, count:inout Int) in 
            
            count = 64 
            
            chunk.withUnsafeBytes
            {
                for (i, value):(Int, UInt32) in zip(buffer.indices, $0.bindMemory(to: UInt32.self))
                {
                    buffer[i] = .init(bigEndian: value)
                }
            }
            
            for i:Int in 16 ..< count 
            {
                let s:(UInt32, UInt32)
                s.0             =   Self.rotate(buffer[i - 15], right:  7) ^ 
                                    Self.rotate(buffer[i - 15], right: 18) ^ 
                                    (buffer[i - 15] >>  3 as UInt32)
                s.1             =   Self.rotate(buffer[i -  2], right: 17) ^
                                    Self.rotate(buffer[i -  2], right: 19) ^ 
                                    (buffer[i -  2] >> 10 as UInt32)
                let t:UInt32    =   s.0 &+ s.1
                buffer[i]       = buffer[i - 16] &+ buffer[i - 7] &+ t
            }
        }
        
        var (a, b, c, d, e, f, g, h):UInt32x8 = self.h
        
        for i:Int in 0 ..< 64 
        {
            let s:(UInt32, UInt32) 
            s.1     =   Self.rotate(e, right:  6) ^ 
                        Self.rotate(e, right: 11) ^ 
                        Self.rotate(e, right: 25)
            s.0     =   Self.rotate(a, right:  2) ^
                        Self.rotate(a, right: 13) ^
                        Self.rotate(a, right: 22)
            let ch:UInt32   = (e & f) ^ (~e & g)
            let temp:(UInt32, UInt32)
            temp.0          = h &+ s.1 &+ ch &+ Self.table[i] &+ schedule[i]
            let maj:UInt32  = (a & b) ^ (a & c) ^ (b & c)
            temp.1          = maj &+ s.0
            
            h = g
            g = f
            f = e
            e = d &+ temp.0
            d = c
            c = b
            b = a
            a = temp.0 &+ temp.1
        }
        
        self.h.0 &+= a
        self.h.1 &+= b
        self.h.2 &+= c
        self.h.3 &+= d
        self.h.4 &+= e
        self.h.5 &+= f
        self.h.6 &+= g
        self.h.7 &+= h
    }
    
    private static 
    func rotate(_ value:UInt32, right shift:Int) -> UInt32 
    {
        (value >> shift) | (value << (UInt32.bitWidth - shift))
    }
}

extension SHA256 
{
    static 
    func hmac<S, C>(_ message:S, key:C) -> [UInt8]
        where   S:Sequence,   S.Element == UInt8,
                C:Collection, C.Element == UInt8 
    {
        let normalized:[UInt8]
        if      key.count > 64 
        {
            normalized = Self.init(for: key).value  + repeatElement(0, count: 32)
        }
        else if key.count < 64 
        {
            normalized = .init(key)                 + repeatElement(0, count: 64 - key.count)
        }
        else 
        {
            normalized = .init(key)
        }
        
        let inner:[UInt8] = normalized.map{ $0 ^ 0x36 },
            outer:[UInt8] = normalized.map{ $0 ^ 0x5c }
        return Self.init(for: outer + Self.init(for: inner + message).value).value
    }
}
