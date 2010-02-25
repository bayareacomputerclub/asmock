package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.framework.constraints.Not;
	import asmock.tests.ExtendedTestCase;

	public class NotFixture extends ExtendedTestCase
	{
		public function NotFixture()
		{
			super();
		}
		
		public function testCtor_NullConstraint() : void
		{
			assertError(null, function():void
			{
				new Not(null);
			}, ArgumentError);
		}
		
		public function testEval_ConstraintReturnsTrue() : void
		{
			var constraint : MockConstraint = new MockConstraint();
			constraint.mock.setupResult("eval", true);
			
			testEvalInternal(constraint, null, false);
		}
		
		public function testEval_ConstraintReturnsFalse() : void
		{
			var constraint : MockConstraint = new MockConstraint();
			constraint.mock.setupResult("eval", false);
			
			testEvalInternal(constraint, null, true);
		}
		
		public function testEval_ObjectPassedToConstraint() : void
		{
			var evalObject : Object = {};
			var evalCalled : Boolean = false;
			
			var constraint : MockConstraint = new MockConstraint();
			constraint.mock.setupProxy("eval", function(obj : Object) : Boolean
			{
				assertStrictlyEquals("Unexpected object passed to eval", evalObject, obj); 
				evalCalled = true;
				return true;
			});
			
			
			testEvalInternal(constraint, evalObject, false);
			
			assertTrue("Expected eval to be called", evalCalled);
		}
		
		public function testMessage() : void
		{
			var constraint : MockConstraint = new MockConstraint();
			constraint.mock.setupResult("message", "test constraint");
			
			testMessageInternal(constraint, "not test constraint");
		}
		
		private function testEvalInternal(innerConstraint : AbstractConstraint, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : Not = new Not(innerConstraint);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected eval result", expectedResult, result);
		}
		
		private function testMessageInternal(innerConstraint : AbstractConstraint, expectedMessage : String) : void
		{
			var constraint : Not = new Not(innerConstraint);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
		
	}
}