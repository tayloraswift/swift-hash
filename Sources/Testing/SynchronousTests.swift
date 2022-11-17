public
protocol SynchronousTests
{
    static
    func run(tests:inout Tests)
}
extension SynchronousTests
{
    public static
    func main() throws
    {
        var tests:Tests = .init()
        Self.run(tests: &tests)
        try tests.summarize()
    }
}
