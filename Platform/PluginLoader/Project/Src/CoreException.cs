﻿// <file>
//     <copyright see="prj:///doc/copyright.txt"/>
//     <license see="prj:///doc/license.txt"/>
//     <owner name="Daniel Grunwald" email="daniel@danielgrunwald.de"/>
//     <version>$Revision: 1624 $</version>
// </file>

using System;
using System.Runtime.Serialization;

namespace TickZoom.Loader
{
	/// <summary>
	/// Base class for exceptions thrown by the TickZoom core.
	/// </summary>
	[Serializable()]
	public class CoreException : Exception
	{
		public CoreException() : base()
		{
		}
		
		public CoreException(string message) : base(message)
		{
		}
		
		public CoreException(string message, Exception innerException) : base(message, innerException)
		{
		}
		
		protected CoreException(SerializationInfo info, StreamingContext context) : base(info, context)
		{
		}
	}
}
