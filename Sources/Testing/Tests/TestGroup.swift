public
struct TestGroup
{
    public
    let tests:Tests
    public
    let path:[String]

    init(_ tests:Tests, path:[String])
    {
        self.tests = tests
        self.path = path
    }
}
extension TestGroup
{
    public static
    func / (self:Self, name:String) -> Self
    {
        .init(self.tests, path: self.path + [name])
    }
}
extension TestGroup
{
    @discardableResult
    public 
    func `do`<Success>(
        function:String = #function,
        file:String = #fileID,
        line:Int = #line,
        _ body:() throws -> Success) -> Success?
    {
        do
        {
            let result:Success = try body()
            self.tests.passed += 1
            return result
        }
        catch let error
        {
            self.tests.failed.append(.init(Assertion.ExpectedSuccess.init(caught: error),
                location: .init(
                    function: function,
                    path: self.path,
                    file: file,
                    line: line)))
            return nil
        }
    }
    public 
    func `do`<Failure>(catching expected:Failure.Type,
        function:String = #function,
        file:String = #fileID,
        line:Int = #line,
        _ body:() throws -> ())
        where Failure:Error
    {
        let failure:Assertion.ExpectedFailure<Failure>
        do
        {
            try body()
            failure = .init(caught: nil)
        }
        catch is Failure
        {
            self.tests.passed += 1
            return
        }
        catch let other
        {
            failure = .init(caught: other)
        }

        self.tests.failed.append(.init(failure,
            location: .init(
                function: function,
                path: self.path,
                file: file,
                line: line)))
    }
    public 
    func `do`<Failure>(catching exact:Failure,
        function:String = #function,
        file:String = #fileID,
        line:Int = #line,
        _ body:() throws -> ())
        where Failure:Error & Equatable
    {
        let failure:Assertion.ExpectedExactFailure<Failure>
        do
        {
            try body()
            failure = .init(caught: nil, expected: exact)
        }
        catch exact as Failure
        {
            self.tests.passed += 1
            return
        }
        catch let other
        {
            failure = .init(caught: other, expected: exact)
        }

        self.tests.failed.append(.init(failure,
            location: .init(
                function: function,
                path: self.path,
                file: file,
                line: line)))
    }
}
#if swift(>=5.5)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension TestGroup
{
    @discardableResult
    public 
    func `do`<Success>(
        function:String = #function,
        file:String = #fileID,
        line:Int = #line,
        _ body:() async throws -> Success) async -> Success?
    {
        do
        {
            let result:Success = try await body()
            self.tests.passed += 1
            return result
        }
        catch let error
        {
            self.tests.failed.append(.init(Assertion.ExpectedSuccess.init(caught: error),
                location: .init(
                    function: function,
                    path: self.path,
                    file: file,
                    line: line)))
            return nil
        }
    }
    public 
    func `do`<Failure>(catching expected:Failure.Type,
        function:String = #function,
        file:String = #fileID,
        line:Int = #line,
        _ body:() async throws -> ()) async
        where Failure:Error
    {
        let failure:Assertion.ExpectedFailure<Failure>
        do
        {
            try await body()
            failure = .init(caught: nil)
        }
        catch is Failure
        {
            self.tests.passed += 1
            return
        }
        catch let other
        {
            failure = .init(caught: other)
        }

        self.tests.failed.append(.init(failure,
            location: .init(
                function: function,
                path: self.path,
                file: file,
                line: line)))
    }
    public 
    func `do`<Failure>(catching exact:Failure,
        function:String = #function,
        file:String = #fileID,
        line:Int = #line,
        _ body:() async throws -> ()) async
        where Failure:Error & Equatable
    {
        let failure:Assertion.ExpectedExactFailure<Failure>
        do
        {
            try await body()
            failure = .init(caught: nil, expected: exact)
        }
        catch exact as Failure
        {
            self.tests.passed += 1
            return
        }
        catch let other
        {
            failure = .init(caught: other, expected: exact)
        }

        self.tests.failed.append(.init(failure,
            location: .init(
                function: function,
                path: self.path,
                file: file,
                line: line)))
    }
}
#endif

extension TestGroup
{
    public 
    func expect(true bool:Bool,
        function:String = #function,
        file:String = #fileID,
        line:Int = #line)  
    {
        if  bool
        {
            self.tests.passed += 1
        }
        else
        {
            self.tests.failed.append(.init(Assertion.ExpectedTrue.init(),
                location: .init(
                    function: function,
                    path: self.path,
                    file: file,
                    line: line)))
        }
    }
    public 
    func expect(false bool:Bool,
        function:String = #function,
        file:String = #fileID,
        line:Int = #line)  
    {
        if  bool
        {
            self.tests.failed.append(.init(Assertion.ExpectedFalse.init(),
                location: .init(
                    function: function,
                    path: self.path,
                    file: file,
                    line: line)))
        }
        else
        {
            self.tests.passed += 1
        }
    }

    public 
    func expect<Expectation>(_ failure:Expectation?,
        function:String = #function, 
        file:String = #fileID, 
        line:Int = #line) 
        where Expectation:AssertionFailure
    {
        if let failure:Expectation = failure
        {
            self.tests.failed.append(.init(failure,
                location: .init(
                    function: function,
                    path: self.path,
                    file: file,
                    line: line)))
        }
        else 
        {
            self.tests.passed += 1
        }
    }
    @discardableResult
    public
    func expect<Wrapped>(value optional:Wrapped?,
        function:String = #function, 
        file:String = #fileID, 
        line:Int = #line) -> Wrapped?
    {
        if  let value:Wrapped = optional
        {
            self.tests.passed += 1
            return value 
        }
        else 
        {
            self.tests.failed.append(.init(Assertion.ExpectedValue<Wrapped>.init(),
                location: .init(
                    function: function,
                    path: self.path,
                    file: file,
                    line: line)))
            return nil
        }
    }
    public
    func expect<Wrapped>(nil optional:Wrapped?,
        function:String = #function, 
        file:String = #fileID, 
        line:Int = #line)
    {
        if  let value:Wrapped = optional
        {
            self.tests.failed.append(.init(Assertion.ExpectedNil<Wrapped>.init(
                    unwrapped: value),
                location: .init(
                    function: function,
                    path: self.path,
                    file: file,
                    line: line)))
        }
        else 
        {
            self.tests.passed += 1
        }
    }
}
