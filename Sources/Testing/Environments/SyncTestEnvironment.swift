#if swift(>=5.7)
public
protocol SyncTestEnvironment<Context>:TestCase
{
    associatedtype Context

    func runWithContext<Success>(tests:inout Tests,
        body:(inout Tests, Context) throws -> Success) throws -> Success
}

#else
public
protocol SyncTestEnvironment:TestCase
{
    associatedtype Context

    func runWithContext<Success>(tests:inout Tests,
        body:(inout Tests, Context) throws -> Success) throws -> Success
}
#endif

extension SyncTestEnvironment where Context == Self
{
    @inlinable public
    func runWithContext<Success>(tests:inout Tests,
        body:(inout Tests, Self) throws -> Success) throws -> Success
    {
        try body(&tests, self)
    }
}
