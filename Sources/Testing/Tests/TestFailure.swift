public
struct TestFailure
{
    public
    let location:Assertion

    #if swift(<5.7)

    public
    let failure:AssertionFailure
    public
    init(_ error:Error, location:Assertion)
    {
        self.location = location
        self.error = error
    }

    #else

    public
    let failure:any AssertionFailure
    public
    init(_ failure:any AssertionFailure, location:Assertion)
    {
        self.location = location
        self.failure = failure
    }
    
    #endif
}
