extension Tests
{
    public final
    class Results
    {
        public
        var passed:Int
        public
        var failed:[Failure]

        init()
        {
            self.passed = 0
            self.failed = []
        }
    }
}
extension Tests.Results
{
    public
    func summarize() throws
    {
        print("passed: \(self.passed) test(s)")
        if self.failed.isEmpty
        {
            return
        }
        print("failed: \(self.failed.count) test(s)")

        for (ordinal, failure):(Int, Tests.Failure) in self.failed.enumerated()
        {
            print("\(ordinal). \(failure)")
        }

        throw Tests.Failures.init()
    }
}
