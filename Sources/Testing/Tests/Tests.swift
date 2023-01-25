public final
class Tests
{
    public
    var passed:Int
    public
    var failed:[TestFailure]

    init()
    {
        self.passed = 0
        self.failed = []
    }
}
extension Tests
{
    var count:Int
    {
        self.passed + self.failed.count
    }
}
extension Tests
{
    public static
    func / (self:Tests, name:String) -> TestGroup
    {
        .init(self, path: [name])
    }
}
extension Tests
{
    private static
    func bold(_ string:String) -> String
    {
        "\u{1B}[1m\(string)\u{1B}[0m"
    }
    private static
    func color(_ string:String) -> String 
    {
        let color:(r:UInt8, g:UInt8, b:UInt8) = (r: 255, g:  51, b:  51)
        return "\u{1B}[38;2;\(color.r);\(color.g);\(color.b)m\(string)\u{1B}[39m"
    }

    public
    func summarize() throws
    {
        if self.failed.isEmpty
        {
            print(Self.bold("All tests passed (\(self.passed) assertion(s))"))
            return
        }

        print(Self.bold(Self.color(
            "Some tests failed (\(self.failed.count) of \(self.count) assertions(s))")))

        for (number, test):(Int, TestFailure) in self.failed.enumerated()
        {
            let assertion:Assertion = test.location
            let description:String =
            """
            \(Self.bold("[\(number)]: \(assertion.path.joined(separator: " / "))"))
            Assertion at \(assertion.file):\(assertion.line) (in \(assertion.function)) failed:
            \(test.failure)
            """

            print(description)
        }

        throw TestFailures.init()
    }
}
