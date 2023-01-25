extension Assertion
{
    public
    struct ExpectedSuccess
    {
        #if swift(<5.7)

        public
        let caught:Error

        public
        init(caught:Error)
        {
            self.caught = caught
        }

        #else

        public
        let caught:any Error

        public
        init(caught:any Error)
        {
            self.caught = caught
        }

        #endif
    }
}
extension Assertion.ExpectedSuccess:AssertionFailure
{
    public
    var description:String
    {
        """
        Expected success, but caught:
        ---------------------
        \(self.caught)
        """
    }
}
