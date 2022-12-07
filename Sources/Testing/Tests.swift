public
struct Tests
{
    public
    var passed:Int
    public
    var failed:[TestFailure]
    public private(set)
    var scope:[String]

    public
    init()
    {
        self.passed = 0
        self.failed = []
        self.scope = []
    }
}

extension Tests
{
    @discardableResult
    public mutating
    func group<T>(_ name:String, running run:(inout Self) -> T) -> T
    {
        self.scope.append(name)
        defer
        {
            self.scope.removeLast()
        }
        return run(&self)
    }

    #if swift(>=5.5)
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    @discardableResult
    public mutating
    func group<T>(_ name:String, running run:@Sendable (inout Self) async -> T) async -> T
    {
        self.scope.append(name)
        defer
        {
            self.scope.removeLast()
        }
        return await run(&self)
    }
    #endif
    
    public
    func summarize() throws
    {
        print("passed: \(self.passed) test(s)")
        if self.failed.isEmpty
        {
            return
        }
        print("failed: \(self.failed.count) test(s)")

        for (ordinal, failure):(Int, TestFailure) in self.failed.enumerated()
        {
            print("\(ordinal). \(failure)")
        }

        throw TestFailures.init()
    }
}

extension Tests
{
    @discardableResult
    public mutating 
    func `do`<T>(name:String,
        function:String = #function, 
        file:String = #file, 
        line:Int = #line, 
        column:Int = #column,
        body:(inout Self) throws -> T) -> T?
    {
        self.group(name)
        {
            do
            {
                let returned:T = try body(&$0)
                $0.passed += 1
                return returned
            }
            catch let error
            {
                $0.failed.append(.init(error,
                    location: .init(function: function, file: file, line: line, column: column),
                    scope: $0.scope))
                return nil
            }
        }
    }
    public mutating 
    func `do`<Thrown>(name:String, expecting expected:Thrown,
        function:String = #function, 
        file:String = #file, 
        line:Int = #line, 
        column:Int = #column,
        body:(inout Self) throws -> ())
        where Thrown:Error & Equatable
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
                $0.passed += 1
                return
            }
            catch let other
            {
                error = .init(thrown: other, expected: expected)
            }

            $0.failed.append(.init(error,
                location: .init(function: function, file: file, line: line, column: column),
                scope: $0.scope))
        }
    }
}

#if swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Tests
{
    @discardableResult
    public mutating 
    func `do`<T>(name:String,
        function:String = #function, 
        file:String = #file, 
        line:Int = #line, 
        column:Int = #column,
        body:@Sendable (inout Self) async throws -> T) async -> T?
    {
        await self.group(name)
        {
            do
            {
                let returned:T = try await body(&$0)
                $0.passed += 1
                return returned
            }
            catch let error
            {
                $0.failed.append(.init(error,
                    location: .init(function: function, file: file, line: line, column: column),
                    scope: $0.scope))
                return nil
            }
        }
    }
    public mutating 
    func `do`<Thrown>(name:String, expecting expected:Thrown,
        function:String = #function, 
        file:String = #file, 
        line:Int = #line, 
        column:Int = #column,
        body:@Sendable (inout Self) async throws -> ()) async
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
                $0.passed += 1
                return
            }
            catch let other
            {
                error = .init(thrown: other, expected: expected)
            }

            $0.failed.append(.init(error,
                location: .init(function: function, file: file, line: line, column: column),
                scope: $0.scope))
        }
    }
}
#endif

extension Tests
{
    public mutating 
    func assert(_ bool:Bool, name:String,
        function:String = #function,
        file:String = #file,
        line:Int = #line,
        column:Int = #column)  
    {
        if  bool
        {
            self.passed += 1
        }
        else
        {
            self.failed.append(.init(AssertionError.init(),
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope + [name]))
        }
    }

    public mutating 
    func assert<Expectation>(_ failure:Expectation?, name:String,
        function:String = #function, 
        file:String = #file, 
        line:Int = #line, 
        column:Int = #column) 
        where Expectation:ExpectationError
    {
        if let failure:Expectation = failure
        {
            self.failed.append(.init(failure,
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope + [name]))
        }
        else 
        {
            self.passed += 1
        }
    }
}
extension Tests
{
    public mutating
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
            self.failed.append(.init(error,
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope + [name]))
            return nil
        }
    }
}
