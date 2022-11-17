#if swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public
protocol AsynchronousTests
{
    static
    func run(tests:inout Tests) async
}
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension AsynchronousTests
{
    public static
    func main() async throws
    {
        var tests:Tests = .init()
        await Self.run(tests: &tests)
        try tests.summarize()
    }
}
#endif
