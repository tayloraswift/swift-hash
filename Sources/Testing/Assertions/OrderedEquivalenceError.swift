infix operator ==? :ComparisonPrecedence
infix operator ..? :ComparisonPrecedence

public
struct OrderedEquivalenceError<Value>:ExpectationError
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
extension OrderedEquivalenceError:CustomStringConvertible
{
    public 
    var description:String
    {
        """
        expected equal values
        {
            lhs: \(lhs),
            rhs: \(rhs)
        }
        """
    }
}

/// Compares the elements of two sequences, enforcing ordering.
/// Perfer this operator over ``==?(_:_:)`` for improved diagnostics.
@inlinable public
func ..? <LHS, RHS>(lhs:LHS, rhs:RHS) -> OrderedEquivalenceError<[LHS.Element]>?
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
/// Compares two elements to equality.
@inlinable public
func ==? <T>(lhs:T, rhs:T) -> OrderedEquivalenceError<T>?
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
