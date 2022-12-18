#if swift(>=5.7)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public
protocol AsyncTestEnvironment<Context>:TestCase
{
    associatedtype Context

    func runWithContext<Success>(tests:inout Tests,
        body:(inout Tests, Context) async throws -> Success) async throws -> Success
}
#elseif swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public
protocol AsyncTestEnvironment:TestCase
{
    associatedtype Context

    func runWithContext<Success>(tests:inout Tests,
        body:(inout Tests, Context) async throws -> Success) async throws -> Success
}
#endif

#if swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension AsyncTestEnvironment where Context == Self
{
    @inlinable public
    func runWithContext<Success>(tests:inout Tests,
        body:(inout Tests, Self) async throws -> Success) async throws -> Success
    {
        try await body(&tests, self)
    }
}
#endif
