public
protocol SyncTestCase:TestCase
{
    func run(tests:inout Tests) throws
}
