#if swift(>=5.7)
public
protocol SyncTestEnvironment<Context>:TestCase
{
    associatedtype Context

    func withContext<Success>(run body:(Context) throws -> Success) throws -> Success
}

#else
public
protocol SyncTestEnvironment:TestCase
{
    associatedtype Context

    func withContext<Success>(run body:(Context) throws -> Success) throws -> Success
}
#endif

extension SyncTestEnvironment where Context == Self
{
    @inlinable public
    func withContext<Success>(run body:(Self) throws -> Success) throws -> Success
    {
        try body(self)
    }
}