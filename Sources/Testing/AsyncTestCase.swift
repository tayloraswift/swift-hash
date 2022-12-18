#if swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public
protocol AsyncTestCase:TestCase
{
    func run(tests:inout Tests) async throws
}
#endif
