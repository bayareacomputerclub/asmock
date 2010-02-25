package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.ArrayLength;
	import asmock.tests.ExtendedTestCase;

	public class ArrayLengthFixture extends ExtendedTestCase
	{
		public function ArrayLengthFixture()
		{
			super();
		}
		
		public function testCtor_NullConstraint() : void
		{
			assertError(null, function():void
			{
				new ArrayLength(null);
			}, ArgumentError);
		}
		
		public function testEval() : void
		{
			testEvalInternal([null, null, null], true, 3, true);
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
			
			var arrayLength : ArrayLength = new ArrayLength(mockConstraint);
			var message : String = arrayLength.message;
			
			assertEquals("Unexpected message value", "array length test message", message);
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
			
			var arrayLength : ArrayLength = new ArrayLength(mockConstraint);
			var actualResult : Boolean = arrayLength.eval(evalObject);
			
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