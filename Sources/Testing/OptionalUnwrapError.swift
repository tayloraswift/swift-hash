public
struct OptionalUnwrapError<Wrapped>:Error, CustomStringConvertible 
{
    public
    init()
    {
    }
    public 
    var description:String
    {
        "expected non-nil value of type \(Wrapped.self)"
    }
}
