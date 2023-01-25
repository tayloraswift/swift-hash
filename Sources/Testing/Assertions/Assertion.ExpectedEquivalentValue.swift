infix operator ==? :ComparisonPrecedence
infix operator ..? :ComparisonPrecedence

extension Assertion
{
    public
    struct ExpectedEquivalentValue<Value>
    {
        public
        let lhs:Value
        public
        let rhs:Value

        @inlinable public
        init(lhs:Value, rhs:Value)
        {
            self.lhs = lhs
            self.rhs = rhs
        }
    }
}
extension Assertion.ExpectedEquivalentValue:AssertionFailure
{
    public 
    var description:String
    {
        """
        Expected equal values:
        {
            lhs: \(self.lhs),
            rhs: \(self.rhs)
        }
        """
    }
}

/// Compares the elements of two sequences, enforcing ordering.
/// Perfer this operator over ``==?(_:_:)`` for improved diagnostics.
@inlinable public
func ..? <LHS, RHS>(lhs:LHS, rhs:RHS) -> Assertion.ExpectedEquivalentValue<[LHS.Element]>?
    where LHS:Sequence, RHS:Sequence, LHS.Element == RHS.Element, LHS.Element:Equatable
{
    let rhs:[LHS.Element] = .init(rhs)
    let lhs:[LHS.Element] = .init(lhs)
    if  lhs.elementsEqual(rhs) 
    {
        return nil 
    }
    else 
    {
        return .init(lhs: lhs, rhs: rhs)
    }
}
/// Compares two elements for equality.
@inlinable public
func ==? <T>(lhs:T, rhs:T) -> Assertion.ExpectedEquivalentValue<T>?
    where T:Equatable
{
    if  lhs == rhs
    {
        return nil 
    }
    else 
    {
        return .init(lhs: lhs, rhs: rhs)
    }
}
