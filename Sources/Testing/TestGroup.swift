public
enum TestGroup:Hashable, Sendable
{
    case mandatory(String)
    case optional(String)
}
extension TestGroup
{
    public
    var name:String
    {
        switch self
        {
        case .mandatory(let name), .optional(let name):
            return name
        }
    }
    var mandatory:Int
    {
        switch self
        {
        case .mandatory: return 1
        case .optional: return 0
        }
    }
}
extension TestGroup:ExpressibleByStringLiteral
{
    public
    init(stringLiteral:String)
    {
        self = .optional(stringLiteral)
    }
}
