public
struct Tests
{
    public private(set)
    var passed:Int

    #if swift(<5.7)
    public private(set)
    var failed:[Error]
    #else
    public private(set)
    var failed:[any Error]
    #endif

    private
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
    public
    struct Failures:Error
    {
    }
    public
    struct Failure<Assertion>:Error, CustomStringConvertible
    {
        public
        let location:SourceLocation
        public
        let assertion:Assertion
        public
        let scope:String

        public
        init(_ assertion:Assertion, location:SourceLocation, scope:String)
        {
            self.assertion = assertion
            self.location = location
            self.scope = scope
        }
        public 
        var description:String
        {
            """
            \(self.scope): \(self.assertion)
            note: at \(self.location)
            """
        }
    }
}
extension Tests
{
    private
    func scope(name:String) -> String
    {
        self.scope.isEmpty ? name : "\(self.scope.joined(separator: ".")).\(name)"
    }
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

        #if swift(<5.7)
        for (ordinal, failure):(Int, Error) in self.failed.enumerated()
        {
            print("\(ordinal). \(failure)")
        }
        #else
        for (ordinal, failure):(Int, any Error) in self.failed.enumerated()
        {
            print("\(ordinal). \(failure)")
        }
        #endif

        throw Failures.init()
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
        do
        {
            let returned:T = try body(&self)
            self.passed += 1
            return returned
        }
        catch let error
        {
            self.failed.append(Failure<Assert.Success>.init(.init(caught: error),
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope(name: name)))
            return nil
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
        let error:Assert.ThrownError<Thrown>
        do
        {
            try body(&self)
            error = .init(thrown: nil, expected: expected)
        }
        catch expected as Thrown
        {
            self.passed += 1
            return
        }
        catch let other
        {
            error = .init(thrown: other, expected: expected)
        }

        self.failed.append(Failure<Assert.ThrownError<Thrown>>.init(error,
            location: .init(function: function, file: file, line: line, column: column),
            scope: self.scope(name: name)))
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
        do
        {
            let returned:T = try await body(&self)
            self.passed += 1
            return returned
        }
        catch let error
        {
            self.failed.append(Failure<Assert.Success>.init(.init(caught: error),
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope(name: name)))
            return nil
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
        let error:Assert.ThrownError<Thrown>
        do
        {
            try await body(&self)
            error = .init(thrown: nil, expected: expected)
        }
        catch expected as Thrown
        {
            self.passed += 1
            return
        }
        catch let other
        {
            error = .init(thrown: other, expected: expected)
        }

        self.failed.append(Failure<Assert.ThrownError<Thrown>>.init(error,
            location: .init(function: function, file: file, line: line, column: column),
            scope: self.scope(name: name)))
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
            self.failed.append(Failure<Assert.True>.init(.init(),
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope(name: name)))
        }
    }

    public mutating 
    func assert<T>(_ failure:Assert.Equivalence<T>?, name:String,
        function:String = #function, 
        file:String = #file, 
        line:Int = #line, 
        column:Int = #column) 
    {
        if let failure:Assert.Equivalence<T> = failure
        {
            self.failed.append(Failure<Assert.Equivalence<T>>.init(failure,
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope(name: name)))
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
            let error:Assert.OptionalUnwrap<Wrapped> = .init()
            self.failed.append(Failure<Assert.OptionalUnwrap<Wrapped>>.init(error,
                location: .init(function: function, file: file, line: line, column: column),
                scope: self.scope(name: name)))
            return nil
        }
    }
}
