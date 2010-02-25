package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.PredicateConstraint;
	import asmock.tests.ExtendedTestCase;

	public class PredicateConstraintFixture extends ExtendedTestCase
	{
		public function PredicateConstraintFixture()
		{
			super();
		}
		
		public function testCtor_NullPredicate() : void
		{
			assertError(null, function():void
			{
				new PredicateConstraint(null);
			}, ArgumentError);
		}
		
		public function testEval_True() : void
		{
			function predicate(obj : Object):Boolean
			{
				return true;
			}
			
			testEvalInternal(predicate, {}, true);
		}
		
		public function testEval_False() : void
		{
			function predicate(obj : Object):Boolean
			{
				return false;
			}
			
			testEvalInternal(predicate, {}, false);
		}
		
		public function testEval_ObjectPassthrough() : void
		{
			var actualObject : Object = null;
			var evalObject : Object = {};
			
			function predicate(obj : Object):Boolean
			{
				actualObject = obj;
				return false;
			}
			
			testEvalInternal(predicate, evalObject, false);
			
			assertStrictlyEquals("Expected object to be passed through to predicate", evalObject, actualObject);
		}
		
		public function testMessage() : void
		{
			function predicate(obj : Object):Boolean
			{
				return true;
			}
			
			testMessageInternal(predicate, "predicate");
		}
		
		private function testEvalInternal(predicate : Function, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : PredicateConstraint = new PredicateConstraint(predicate);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(predicate : Function, expectedMessage : String) : void
		{
			var constraint : PredicateConstraint = new PredicateConstraint(predicate);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
		
	}
}