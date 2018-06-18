// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

namespace System.StubHelpers {
    internal static class EventArgsMarshaler {
        static internal IntPtr CreateNativePCEventArgsInstance(string name) {
            throw new PlatformNotSupportedException ();                        
        }
        static internal IntPtr CreateNativeNCCEventArgsInstance(int action, object newItems, object oldItems, int newIndex, int oldIndex) {
            throw new PlatformNotSupportedException ();
        }
    }

    internal static class InterfaceMarshaler {
        static internal object ConvertToManagedWithoutUnboxing(IntPtr pNative) {
            throw new PlatformNotSupportedException ();            
        }
    }
}
