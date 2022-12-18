extension Tests
{
    public
    struct Failure:Error
    {
        public
        let location:SourceLocation?
        public
        let scope:[String]

        #if swift(<5.7)

        public
        let error:Error
        public
        init(_ error:Error, location:SourceLocation? = nil, scope:[String])
        {
            self.error = error
            self.location = location
            self.scope = scope
        }

        #else

        public
        let error:any Error
        public
        init(_ error:any Error, location:SourceLocation? = nil, scope:[String])
        {
            self.error = error
            self.location = location
            self.scope = scope
        }
        
        #endif
    }
}
extension Tests.Failure:CustomStringConvertible
{
    public 
    var description:String
    {
        var description:String =
        """
        \(self.scope.joined(separator: ".")): \(self.error)
        """
        if let location:SourceLocation = self.location
        {
            description +=
            """
            note: at \(location)
            """
        }
        return description
    }
}
