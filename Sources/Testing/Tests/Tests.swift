public
struct Tests
{
    public
    let results:Results
    public
    let scope:[String]

    init(results:Results, scope:[String])
    {
        self.results = results
        self.scope = scope
    }
}
extension Tests
{
    public
    init()
    {
        self.init(results: .init(), scope: [])
    }
}

extension Tests
{
    func appending(scope:String) -> Self
    {
        .init(results: self.results, scope: self.scope + [scope])
    }
}

extension Tests
{
    /// Creates a testing scope with the given namespace added.
    /// The method is `mutating` to prevent accidental use of the
    /// test bench outside of the closure.
    @discardableResult
    public mutating
    func group<T>(_ namespace:String, body:(inout Self) -> T) -> T
    {
        var group:Self = self.appending(scope: namespace)
        return body(&group)
    }

    @discardableResult
    public mutating 
    func test<T>(name:String,
        body:(inout Self) throws -> T) -> T?
    {
        self.group(name)
        {
            do
            {
                let returned:T = try body(&$0)
                $0.results.passed += 1
                return returned
            }
            catch let error
            {
                $0.results.failed.append(.init(error, scope: $0.scope))
                return nil
            }
        }
    }
    @discardableResult
    public mutating 
    func test<T, Environment>(with environment:Environment,
        body:(inout Self, Environment.Context) throws -> T) -> T?
        where   Environment:SyncTestEnvironment
    {
        self.test(name: environment.name)
        {
            try environment.runWithContext(tests: &$0, body: body)
        }
    }
    public mutating 
    func test<Case>(case:Case)
        where   Case:SyncTestCase
    {
        self.test(name: `case`.name, body: `case`.run(tests:)) ?? ()
    }
    public mutating
    func test<Case, Thrown>(case:Case, expecting error:Thrown)
        where   Case:SyncTestCase,
                Thrown:Error & Equatable
    {
        self.test(name: `case`.name, expecting: error, body: `case`.run(tests:))
    }
    public mutating 
    func test<Thrown>(name:String, expecting expected:Thrown,
        body:(inout Self) throws -> ())
        where   Thrown:Error & Equatable
    {
        self.group(name)
        {
            let error:ExpectedFailureError<Thrown>
            do
            {
                try body(&$0)
                error = .init(thrown: nil, expected: expected)
            }
            catch expected as Thrown
            {
                $0.results.passed += 1
                return
            }
            catch let other
            {
                error = .init(thrown: other, expected: expected)
            }

            $0.results.failed.append(.init(error, scope: $0.scope))
        }
    }
}

#if swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Tests
{
    /// Creates an asynchronous testing scope with the given namespace
    /// added. The method is `mutating` to prevent accidental use of
    /// the test bench outside of the closure.
    @discardableResult
    public mutating
    func group<T>(_ namespace:String, running run:(inout Self) async -> T) async -> T
    {
        var group:Self = self.appending(scope: namespace)
        return await run(&group)
    }

    @discardableResult
    public mutating 
    func test<T>(name:String,
        body:(inout Self) async throws -> T) async -> T?
    {
        await self.group(name)
        {
            do
            {
                let returned:T = try await body(&$0)
                $0.results.passed += 1
                return returned
            }
            catch let error
            {
                $0.results.failed.append(.init(error, scope: $0.scope))
                return nil
            }
        }
    }

    @discardableResult
    public mutating 
    func test<T, Environment>(with environment:Environment,
        body:(inout Self, Environment.Context) async throws -> T) async -> T?
        where   Environment:AsyncTestEnvironment
    {
        await self.test(name: environment.name)
        {
            try await environment.runWithContext(tests: &$0, body: body)
        }
    }
    public mutating 
    func test<Case>(case:Case) async 
        where   Case:AsyncTestCase
    {
        await self.test(name: `case`.name, body: `case`.run(tests:)) ?? ()
    }
    public mutating
    func test<Case, Thrown>(case:Case, expecting error:Thrown) async 
        where   Case:AsyncTestCase,
                Thrown:Error & Equatable
    {
        await self.test(name: `case`.name, expecting: error, body: `case`.run(tests:))
    }

    public mutating 
    func test<Thrown>(name:String, expecting expected:Thrown,
        body:(inout Self) async throws -> ()) async
        where Thrown:Error & Equatable
    {
        await self.group(name)
        {
            let error:ExpectedFailureError<Thrown>
            do
            {
                try await body(&$0)
                error = .init(thrown: nil, expected: expected)
            }
            catch expected as Thrown
            {
                $0.results.passed += 1
                return
            }
            catch let other
            {
                error = .init(thrown: other, expected: expected)
            }

            $0.results.failed.append(.init(error, scope: $0.scope))
        }
    }
}
#endif

extension Tests
{
    public 
    func assert(_ bool:Bool, name:String,
        function:String = #function,
        file:String = #file,
        line:Int = #line,
        column:Int = #column)  
    {
        if  bool
        {
            self.results.passed += 1
        }
        else
        {
            self.results.failed.append(.init(AssertionError.init(),
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope + [name]))
        }
    }

    public 
    func assert<Expectation>(_ failure:Expectation?, name:String,
        function:String = #function, 
        file:String = #file, 
        line:Int = #line, 
        column:Int = #column) 
        where Expectation:ExpectationError
    {
        if let failure:Expectation = failure
        {
            self.results.failed.append(.init(failure,
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope + [name]))
        }
        else 
        {
            self.results.passed += 1
        }
    }
}
extension Tests
{
    public
    func unwrap<Wrapped>(_ optional:Wrapped?, name:String,
        file:String = #file, 
        function:String = #function, 
        line:Int = #line, 
        column:Int = #column) -> Wrapped?
    {
        if let wrapped:Wrapped = optional
        {
            return wrapped 
        }
        else 
        {
            let error:OptionalUnwrapError<Wrapped> = .init()
            self.results.failed.append(.init(error,
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope + [name]))
            return nil
        }
    }
}
