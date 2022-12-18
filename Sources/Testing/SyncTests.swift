public
protocol SyncTests
{
    static
    func run(tests:inout Tests)
}
extension SyncTests
{
    public static
    func main() throws
    {
        var tests:Tests = .init()
        Self.run(tests: &tests)
        try tests.results.summarize()
    }
}
