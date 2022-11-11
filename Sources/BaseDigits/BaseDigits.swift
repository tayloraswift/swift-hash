public
protocol BaseDigits
{
    /// Gets the ASCII value for the given remainder.
    static
    subscript(remainder:UInt8) -> UInt8 { get }
}
extension BaseDigits
{
    @inlinable public static
    subscript(remainder:UInt8, as _:Unicode.Scalar.Type = Unicode.Scalar.self) -> Unicode.Scalar
    {
        .init(Self[remainder])
    }
    @inlinable public static
    subscript(remainder:UInt8, as _:Character.Type = Character.self) -> Character
    {
        .init(Self[remainder, as: Unicode.Scalar.self])
    }
}
