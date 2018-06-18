// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

// Mono doesn't have System.Reflection.TypeExtensions which is needed by
// InteropExtensions.
namespace System.Runtime.InteropServices
{
    internal static class TypeExtensions
    {
        public static bool IsInstanceOfType(Type type, object o)
        {
            return type.IsInstanceOfType(o);
        }
    }
}
