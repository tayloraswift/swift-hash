extension Assertion
{
    public
    struct ExpectedFailure<Expected> where Expected:Error
    {
        #if swift(<5.7)

        public
        let caught:Error?

        public
        init(caught:Error?)
        {
            self.caught = caught
        }

        #else

        public
        let caught:(any Error)?

        public
        init(caught:(any Error)?)
        {
            self.caught = caught
        }

        #endif
    }
}
extension Assertion.ExpectedFailure:AssertionFailure
{
    #if swift(<5.7)
    public
    var description:String
    {
        if let caught:Error = self.caught
        {
            return 
                """
                Expected error of type \(String.init(reflecting: Expected.self)), but caught:
                ---------------------
                \(caught)
                """
        }
        else
        {
            return
                """
                Expected error of type \(String.init(reflecting: Expected.self))
                """
        }
    }
    #else
    public
    var description:String
    {
        if let caught:any Error = self.caught
        {
            return 
                """
                Expected error of type \(String.init(reflecting: Expected.self)), but caught:
                ---------------------
                \(caught)
                """
        }
        else
        {
            return
                """
                Expected error of type \(String.init(reflecting: Expected.self))
                """
        }
    }
    #endif
}
