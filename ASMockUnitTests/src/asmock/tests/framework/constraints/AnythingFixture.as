package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.Anything;
	import asmock.tests.ExtendedTestCase;
	
	public class AnythingFixture extends ExtendedTestCase
	{
		public function AnythingFixture()
		{
		}
		
		public function testEval() : void
		{
			var anything : Anything = new Anything();
			
			var result : Boolean = anything.eval(null);
			
			assertTrue("Unexpected eval result", result);
		}
		
		public function testMessage() : void
		{
			var anything : Anything = new Anything();
			
			var message : String = anything.message;
			
			assertEquals("Unexpected message value", "anything", message);
		}

	}
}