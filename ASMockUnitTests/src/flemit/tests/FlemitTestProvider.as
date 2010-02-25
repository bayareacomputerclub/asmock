package flemit.tests
{
	import flemit.tests.framework.SWFOutputFixture;
	import flemit.tests.framework.bytecode.*;
	
	import flexunit.framework.TestSuite;
	
	import org.flexunit.internals.runners.FlexUnit1ClassRunner;
	
	public class FlemitTestProvider
	{
		public function FlemitTestProvider()
		{
		}
		
		public function addTests(suite : TestSuite) : void
		{
			// flemit.tests.framework
			suite.addTestSuite(SWFOutputFixture);
			
			// flemit.tests.framework.bytecode
			suite.addTestSuite(ByteCodeWriterFixture);
		}
	}
}