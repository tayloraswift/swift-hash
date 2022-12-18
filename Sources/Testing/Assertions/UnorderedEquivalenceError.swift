infix operator **? :ComparisonPrecedence

public
struct UnorderedEquivalenceError<Element>:ExpectationError where Element:Hashable
{
    public
    let lhs:Set<Element>
    public
    let rhs:Set<Element>

    @inlinable public
    init(lhs:Set<Element>, rhs:Set<Element>)
    {
        self.lhs = lhs
        self.rhs = rhs
    }
}
extension UnorderedEquivalenceError:CustomStringConvertible
{
    public 
    var description:String
    {
        """
        expected equal elements
        {
            lhs: \(self.lhs),
            rhs: \(self.rhs)
        }
        """
    }
}

/// Compares the elements of two sequences, without enforcing ordering.
/// Perfer this operator over ``==?(_:_:)`` for improved diagnostics.
@inlinable public
func **? <LHS, RHS>(lhs:LHS, rhs:RHS) -> OrderedEquivalenceError<Set<LHS.Element>>?
    where LHS:Sequence, RHS:Sequence, LHS.Element == RHS.Element, LHS.Element:Hashable
{
    let rhs:Set<LHS.Element> = .init(rhs)
    let lhs:Set<LHS.Element> = .init(lhs)
    if  lhs == rhs
    {
        return nil 
    }
    else 
    {
        return .init(lhs: lhs, rhs: rhs)
    }
}
