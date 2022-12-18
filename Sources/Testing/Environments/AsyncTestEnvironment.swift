#if swift(>=5.7)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public
protocol AsyncTestEnvironment<Context>
{
    associatedtype Context

    func withContext<Success>(tests:inout Tests,
        run body:(inout Tests, Context) async throws -> Success) async throws -> Success
}
#elseif swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public
protocol AsyncTestEnvironment
{
    associatedtype Context

    func withContext<Success>(tests:inout Tests,
        run body:(inout Tests, Context) async throws -> Success) async throws -> Success
}
#endif

#if swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension AsyncTestEnvironment where Context == Self
{
    @inlinable public
    func withContext<Success>(tests:inout Tests,
        run body:(inout Tests, Self) async throws -> Success) async throws -> Success
    {
        try await body(&tests, self)
    }
}
#endif
