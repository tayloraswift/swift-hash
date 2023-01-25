public
protocol SyncTests
{
    static
    func run(tests:Tests)
}
extension SyncTests
{
    public static
    func main() throws
    {
        let tests:Tests = .init()
        Self.run(tests: tests)
        try tests.summarize()
    }
}
