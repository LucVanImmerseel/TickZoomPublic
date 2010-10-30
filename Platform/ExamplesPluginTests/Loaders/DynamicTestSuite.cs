﻿#region Copyright
/*
 * Software: TickZoom Trading Platform
 * Copyright 2009 M. Wayne Walter
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * Business use restricted to 30 days except as otherwise stated in
 * in your Service Level Agreement (SLA).
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.tickzoom.org/wiki/Licenses>
 * or write to Free Software Foundation, Inc., 51 Franklin Street,
 * Fifth Floor, Boston, MA  02110-1301, USA.
 * 
 */
#endregion


using System;
using NUnit.Core;
using NUnit.Core.Builders;
using NUnit.Core.Extensibility;
using TickZoom.Api;

namespace Loaders
{
	[SuiteBuilder]
	public class DynamicTestSuite : ISuiteBuilder
	{
		private static readonly Log log = Factory.SysLog.GetLogger(typeof(DynamicTestSuite));
		public Test BuildFrom(Type type)
		{
			var autoTestFixture = (IAutoTestFixture) Reflect.Construct(type);
			var mainSuite = new TestSuite("Dynamic");
			var suite = new TestSuite("Historical");
			mainSuite.Add(suite);
			AddDynamicTestFixtures(suite,autoTestFixture, AutoTestMode.Historical);
			suite = new TestSuite("Realtime");
			mainSuite.Add(suite);
			AddDynamicTestFixtures(suite,autoTestFixture, AutoTestMode.RealTime);
			suite = new TestSuite("FIXSimulator");
			mainSuite.Add(suite);
			AddDynamicTestFixtures(suite,autoTestFixture, AutoTestMode.RealTime);
			return mainSuite;
		}
		
		private void AddDynamicTestFixtures(TestSuite suite, IAutoTestFixture autoTestFixture, AutoTestMode autoTestMode) {
			foreach( var testSettings in autoTestFixture.GetAutoTestSettings() ) {
				testSettings.Mode = autoTestMode;
				try { 
					AddDynamicTestCases(suite, testSettings);
				} catch( ApplicationException ex) {
					if( !ex.Message.Contains("not found")) {
						throw;
					}
				}
			}
		}
			
		private void AddDynamicTestCases(TestSuite suite, AutoTestSettings testSettings) {
			var userFixtureType = typeof(StrategyTest);
			var strategyTest = (StrategyTest) Reflect.Construct(userFixtureType, new object[] { testSettings } );
			var fixture = new NUnitTestFixture(userFixtureType, new object[] { testSettings } );
			fixture.TestName.Name = testSettings.Name;
			foreach( var modelName in strategyTest.GetModelNames()) {
				var paramaterizedTest = new ParameterizedMethodSuite(modelName);
				fixture.Add(paramaterizedTest);
				var parms = new ParameterSet();
				parms.Arguments = new object[] { modelName };
				var modelNames = strategyTest.GetType().GetMethods();
				foreach( var method in modelNames ) {
					var parameters = method.GetParameters();
					if( !method.IsSpecialName && method.IsPublic && parameters.Length == 1 && parameters[0].ParameterType == typeof(string)) {
						var testCase = NUnitTestCaseBuilder.BuildSingleTestMethod(method,parms);
						testCase.TestName.Name = method.Name;
						paramaterizedTest.Add( testCase);
					}
				}
			}
			suite.Add(fixture);
		}
	
		public bool CanBuildFrom(Type type)
		{
			var result = false;
			if( Reflect.HasAttribute( type, typeof(AutoTestFixtureAttribute).FullName, false) 
			   && Reflect.HasInterface( type, typeof(IAutoTestFixture).FullName) ) {
				var autoTestFixture = (IAutoTestFixture) Reflect.Construct(type);
				foreach( var testSettings in autoTestFixture.GetAutoTestSettings() ) {
					var userFixtureType = typeof(StrategyTest);
					var strategyTest = (StrategyTest) Reflect.Construct(userFixtureType, new object[] { testSettings } );
					try {
						foreach( var modelName in strategyTest.GetModelNames()) {
							result = true; // If at least one entry.
							break;
						}
					} catch( ApplicationException ex) {
						if( !ex.Message.Contains("not found") ) {
							log.Error("Model Loader '" + testSettings.LoaderName + "' was unable to load dynamically.");
							throw;
						}
					}
				}
			}
			return result;
		}		
	}
	
    public class ParameterizedMethodSuite : TestSuite
    {
        public ParameterizedMethodSuite(string name)
            : base(name, name)
        {
            this.maintainTestOrder = true;
        }

        public override TestResult Run(EventListener listener, ITestFilter filter)
        {
            if (this.Parent != null)
            {
                this.Fixture = this.Parent.Fixture;
                TestSuite suite = this.Parent as TestSuite;
                if (suite != null)
                {
                    this.setUpMethods = suite.GetSetUpMethods();
                    this.tearDownMethods = suite.GetTearDownMethods();
                }
            }
            return base.Run(listener, filter);
        }

        protected override void DoOneTimeSetUp(TestResult suiteResult)
        {
        }
        protected override void DoOneTimeTearDown(TestResult suiteResult)
        {
        }
    }
}