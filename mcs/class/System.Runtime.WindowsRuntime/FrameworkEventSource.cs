namespace System.Diagnostics.Tracing {
    sealed internal class FrameworkEventSource : EventSource {
        public static readonly FrameworkEventSource Log = new FrameworkEventSource();

        public static class Keywords {
            public const EventKeywords Loader     = (EventKeywords)0x0001; // This is bit 0
            public const EventKeywords ThreadPool = (EventKeywords)0x0002; 
            public const EventKeywords NetClient  = (EventKeywords)0x0004;
            public const EventKeywords DynamicTypeUsage = (EventKeywords)0x0008;
            public const EventKeywords ThreadTransfer   = (EventKeywords)0x0010;
        }
    }
}
