// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

// System.Private.Interop expects there to be an SR.GetResourceString() method.
partial class SR
{
	internal static string GetResourceString(string resourceKey, string defaultString) {
		return defaultString ?? resourceKey;
	}
}
