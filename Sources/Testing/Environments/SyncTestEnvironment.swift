#if swift(>=5.7)
public
protocol SyncTestEnvironment<Context>
{
    associatedtype Context

    func withContext<Success>(tests:inout Tests,
        run body:(inout Tests, Context) throws -> Success) throws -> Success
}

#else
public
protocol SyncTestEnvironment
{
    associatedtype Context

    func withContext<Success>(tests:inout Tests,
        run body:(inout Tests, Context) throws -> Success) throws -> Success
}
#endif
extension SyncTestEnvironment where Context == Self
{
    @inlinable public
    func withContext<Success>(tests:inout Tests,
        run body:(inout Tests, Self) throws -> Success) throws -> Success
    {
        try body(&tests, self)
    }
}
