public
struct AssertionError:Error, CustomStringConvertible  
{
    public
    init()
    {
    }
    public 
    var description:String
    {
        "expected true"
    }
}
