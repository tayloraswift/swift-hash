infix operator ~=? : ComparisonPrecedence

public
struct RangeError<Sample>:ExpectationError where Sample:Comparable
{
    public
    let allowed:ClosedRange<Sample>
    public
    let sampled:Sample

    @inlinable public
    init(allowed:ClosedRange<Sample>, sampled:Sample)
    {
        self.sampled = sampled
        self.allowed = allowed
    }
}
extension RangeError:CustomStringConvertible
{
    public
    var description:String
    {
        """
        expected value within range
        {
            allowed: \(self.allowed.lowerBound) ... \(self.allowed.upperBound),
            sampled: \(self.sampled)
        }
        """
    }
}

public
func ~=? <Sample>(allowed:ClosedRange<Sample>, sampled:Sample) -> RangeError<Sample>?
{
    allowed ~= sampled ? nil : .init(allowed: allowed, sampled: sampled)
}
