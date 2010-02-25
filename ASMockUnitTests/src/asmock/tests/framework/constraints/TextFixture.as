package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.framework.constraints.Contains;
	import asmock.framework.constraints.EndsWith;
	import asmock.framework.constraints.Like;
	import asmock.framework.constraints.StartsWith;
	import asmock.framework.constraints.Text;
	import asmock.tests.ExtendedTestCase;
	
	/**
	 * This fixture tests a static helper class, so the 
	 * tests just ensure the class returned is correct and also 
	 * provides simple pass/fail eval parameters to ensure any
	 * parameters were passed through correctly.
	 */
	public class TextFixture extends ExtendedTestCase
	{
		public function TextFixture()
		{
		}
		
		public function testContains() : void
		{
			testEval(Text.contains("test"), Contains, "testing", "toast");
		}
		
		public function testStartsWith() : void
		{
			testEval(Text.startsWith("test"), StartsWith, "testing", "atest");
		}
		
		public function testEndsWith() : void
		{
			testEval(Text.endsWith("ting"), EndsWith, "testing", "test");
		}
		
		public function testLike() : void
		{
			testEval(Text.like(/^[^\.]+$/), Like, "testing", "test.ing");
		}
		
		private function testEval(constraint : AbstractConstraint, constraintClass : Class, passEvalObject : Object, failEvalObject : Object) : void
		{
			assertTrue("Unexpected constraint type returned", constraint is constraintClass);
			
			var result : Boolean = constraint.eval(passEvalObject);
			assertTrue("Unexpected eval result", result);
			
			result = constraint.eval(failEvalObject);
			assertFalse("Unexpected eval result", result);
		}
	}
}