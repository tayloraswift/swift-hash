public
struct TestFailure<Assertion>:Error where Assertion:Error
{
    public
    let location:SourceLocation
    public
    let assertion:Assertion
    public
    let scope:[String]

    public
    init(_ assertion:Assertion, location:SourceLocation, scope:[String])
    {
        self.assertion = assertion
        self.location = location
        self.scope = scope
    }
}
extension TestFailure:CustomStringConvertible
{
    public 
    var description:String
    {
        """
        \(self.scope.joined(separator: ".")): \(self.assertion)
        note: at \(self.location)
        """
    }
}
