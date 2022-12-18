public
protocol SyncTestEnvironment<Context>
{
    associatedtype Context

    func withContext<Success>(
        _ body:(Context) throws -> Success) rethrows -> Success
}
extension SyncTestEnvironment where Context == Self
{
    @inlinable public
    func withContext<Success>(
        _ body:(Self) throws -> Success) rethrows -> Success
    {
        try body(self)
    }
}
