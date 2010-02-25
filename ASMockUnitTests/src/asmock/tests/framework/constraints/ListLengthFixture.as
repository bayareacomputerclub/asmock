package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.ListLength;
	import asmock.tests.ExtendedTestCase;
	
	import mx.collections.ArrayList;

	public class ListLengthFixture extends ExtendedTestCase
	{
		public function ListLengthFixture()
		{
			super();
		}
		
		public function testCtor_NullConstraint() : void
		{
			assertError(null, function():void
			{
				new ListLength(null);
			}, ArgumentError);
		}
		
		public function testEval() : void
		{
			testEvalInternal(new ArrayList([null, null, null]), true, 3, true);
		}
		
		public function testEval_NotArray() : void
		{
			testEvalInternal({}, false, -1, false);
		}
		
		public function testEval_Null() : void
		{
			testEvalInternal(null, false, -1, false);
		}
		
		public function testMessage() : void
		{
			var mockConstraint : MockConstraint = new MockConstraint();
			mockConstraint.mock.setupResult("message", "test message");
			
			var listLength : ListLength = new ListLength(mockConstraint);
			var message : String = listLength.message;
			
			assertEquals("Unexpected message value", "list length test message", message);
		}
		
		private function testEvalInternal(evalObject : Object, expectCall : Boolean, expectedLength : int, returnResult : Boolean) : void
		{
			var mockConstraint : MockConstraint = new MockConstraint();
			
			var constraintCalled : Boolean = false;
			var actualLength : Object = null;
			
			if (expectCall)
			{
				mockConstraint.mock.setupProxy("eval", function(length : Object) : Boolean
				{
					constraintCalled = true;
					actualLength = length;
					
					return returnResult;
				});
			}
			
			var listLength : ListLength = new ListLength(mockConstraint);
			var actualResult : Boolean = listLength.eval(evalObject);
			
			assertEquals("Unexpected method call", expectCall, constraintCalled);
			
			if (expectCall)
			{
				assertEquals("Unexpected value passed to constraint", expectedLength, actualLength);
				assertEquals("Unexpected eval result", returnResult, actualResult);
			}
			else
			{
				assertEquals("Unexpected eval result", false, actualResult);
			}
		}
	}
}