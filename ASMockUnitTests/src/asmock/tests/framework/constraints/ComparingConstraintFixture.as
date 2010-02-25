package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.ComparingConstraint;
	import asmock.tests.ExtendedTestCase;
	
	public class ComparingConstraintFixture extends ExtendedTestCase
	{
		public function ComparingConstraintFixture()
		{
		}
		
		public function testEval_GreaterThan() : void
		{
			testEvalInternal(5, true, false, 6, true); // greater
			testEvalInternal(5, true, false, 5, false); // equal
			testEvalInternal(5, true, false, 4, false); // less
		}
		
		public function testEval_GreaterThanOrEquals() : void
		{
			testEvalInternal(5, true, true, 6, true); // greater
			testEvalInternal(5, true, true, 5, true); // equal
			testEvalInternal(5, true, true, 4, false); // less
		}
		
		public function testEval_LessThan() : void
		{
			testEvalInternal(5, false, false, 6, false); // greater
			testEvalInternal(5, false, false, 5, false); // equal
			testEvalInternal(5, false, false, 4, true); // less
		}
		
		public function testEval_LessThanOrEquals() : void
		{
			testEvalInternal(5, false, true, 6, false); // greater
			testEvalInternal(5, false, true, 5, true); // equal
			testEvalInternal(5, false, true, 4, true); // less
		}
		
		public function testEval_Null() : void
		{
			testEvalInternal(5, true, true, null, false); // greater
		}
		
		public function testEval_CompareValueNotComparable() : void
		{
			testEvalInternal({}, true, true, 1, false); // greater
		}
		
		public function testEval_EvalValueNotComparable() : void
		{
			testEvalInternal(5, true, true, {}, false); // greater
		}
		
		public function testMessage_GreaterThan() : void
		{
			testMessageInternal(5, true, false, "greater than 5");
		}
		
		public function testMessage_GreaterThanOrEquals() : void
		{
			testMessageInternal(5, true, true, "greater than or equal to 5");
		}
		
		public function testMessage_LessThan() : void
		{
			testMessageInternal(5, false, false, "less than 5");
		}
		
		public function testMessage_LessThanOrEquals() : void
		{
			testMessageInternal(5, false, true, "less than or equal to 5");
		}
		
		private function testEvalInternal(compareValue : Object, greaterThan : Boolean, equalTo : Boolean, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : ComparingConstraint = new ComparingConstraint(compareValue, greaterThan, equalTo);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}
		
		private function testMessageInternal(compareValue : Object, greaterThan : Boolean, equalTo : Boolean, expectedMessage : String) : void
		{
			var constraint : ComparingConstraint = new ComparingConstraint(compareValue, greaterThan, equalTo);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}