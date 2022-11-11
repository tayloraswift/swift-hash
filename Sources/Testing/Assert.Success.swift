extension Assert
{
    public
    struct Success:CustomStringConvertible
    {
        #if swift(<5.7)

        public
        let caught:Error

        public
        init(caught:Error)
        {
            self.caught = caught
        }

        #else

        public
        let caught:any Error

        public
        init(caught:any Error)
        {
            self.caught = caught
        }
        
        #endif

        public 
        var description:String
        {
            "caught error '\(self.caught)'"
        }
    }
}
