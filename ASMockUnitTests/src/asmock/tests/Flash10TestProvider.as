package asmock.tests
{
	import asmock.tests.framework.*;
	import asmock.tests.framework.constraints.*;
	import asmock.tests.framework.impl.*;
	import asmock.tests.framework.methodRecorders.UnorderedMethodRecorderFixture;
	import asmock.tests.reflection.MethodInfoFixture;
	import asmock.tests.reflection.TypeFixture;
	
	import flexunit.framework.TestSuite;
	
	public class Flash10TestProvider
	{
		public function Flash10TestProvider()
		{
		}
		
		public function addTests(suite : TestSuite) : void
		{
			// asmock.tests.framework
			suite.addTestSuite(VectorFixture);
		}
	}
}