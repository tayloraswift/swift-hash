public
struct TestFailure:Error
{
    public
    let location:SourceLocation
    public
    let scope:[String]

    #if swift(<5.7)

    public
    let error:Error
    public
    init(_ error:Error, location:SourceLocation, scope:[String])
    {
        self.error = error
        self.location = location
        self.scope = scope
    }

    #else

    public
    let error:any Error
    public
    init(_ error:any Error, location:SourceLocation, scope:[String])
    {
        self.error = error
        self.location = location
        self.scope = scope
    }
    
    #endif
}
extension TestFailure:CustomStringConvertible
{
    public 
    var description:String
    {
        """
        \(self.scope.joined(separator: ".")): \(self.error)
        note: at \(self.location)
        """
    }
}
