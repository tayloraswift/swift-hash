extension Assertion
{
    public
    struct ExpectedExactFailure<Failure> where Failure:Error & Equatable
    {
        public
        let expected:Failure

        #if swift(<5.7)

        public
        let caught:Error?

        public
        init(caught:Error?, expected:Failure)
        {
            self.caught = caught
            self.expected = expected
        }

        #else

        public
        let caught:(any Error)?

        public
        init(caught:(any Error)?, expected:Failure)
        {
            self.caught = caught
            self.expected = expected
        }

        #endif
    }
}
extension Assertion.ExpectedExactFailure:AssertionFailure
{
    #if swift(<5.7)
    public
    var description:String
    {
        if let caught:Error = self.caught
        {
            return 
                """
                Expected error with exact value:
                ---------------------
                \(self.expected)
                ---------------------
                But caught:
                ---------------------
                \(caught)
                """
        }
        else
        {
            return
                """
                Expected error with exact value:
                ---------------------
                \(self.expected)
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
                Expected error with exact value:
                ---------------------
                \(self.expected)
                ---------------------
                But caught:
                ---------------------
                \(caught)
                """
        }
        else
        {
            return
                """
                Expected error with exact value:
                ---------------------
                \(self.expected)
                """
        }
    }
    #endif
}
