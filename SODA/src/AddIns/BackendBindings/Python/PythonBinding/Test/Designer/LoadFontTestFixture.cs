// <file>
//     <copyright see="prj:///doc/copyright.txt"/>
//     <license see="prj:///doc/license.txt"/>
//     <owner name="Matthew Ward" email="mrward@users.sourceforge.net"/>
//     <version>$Revision: 3936 $</version>
// </file>

using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

using ICSharpCode.PythonBinding;
using NUnit.Framework;
using PythonBinding.Tests.Utils;

namespace PythonBinding.Tests.Designer
{
	[TestFixture]
	public class LoadFontTestFixture : LoadFormTestFixtureBase
	{
		public override string PythonCode {
			get {
				return "class TestForm(System.Windows.Forms.Form):\r\n" +
							"    def InitializeComponent(self):\r\n" +
							"        self.SuspendLayout()\r\n" +
							"        # \r\n" +
							"        # TestForm\r\n" +
							"        # \r\n" +
							"        self.Font = System.Drawing.Font(\"Times New Roman\", 8.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 1)\r\n" +
							"        self.Name = \"TestForm\"\r\n" +
							"        self.ResumeLayout(False)\r\n";
			}
		}
		
		[Test]
		public void FormBackColor()
		{
			Font font = new Font("Times New Roman", 8.25F, FontStyle.Regular, GraphicsUnit.Point, 1);
			Assert.AreEqual(font, Form.Font);
		}
	}
}
