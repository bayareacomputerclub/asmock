package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.ArrayEquals;
	import asmock.tests.ExtendedTestCase;
	
	public class ArrayEqualsFixture extends ExtendedTestCase
	{
		public function ArrayEqualsFixture()
		{
		}
		
		public function testCtor_NullArray() : void
		{
			assertError(null, function():void
			{
				new ArrayEquals(null);
			}, ArgumentError);
		}
		
		public function testCtor_EmptyArray() : void
		{
			new ArrayEquals([]);
		}
		
		public function testEval_Success() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], [1.0, "test", anObject], true);
		}
		
		public function testEval_FailFirst() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], [1.1, "test", anObject], false);
		}
		
		public function testEval_FailLast() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], [1.0, "test", null], false);
		}
		
		public function testEval_FailDifferentLengths() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], [1.0, "test"], false);
		}
		
		public function testEval_NotArray() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], anObject, false);	
		}
		
		public function testEval_Null() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], null, false);
		}
		
		public function testMessage() : void
		{
			var anObject : Object = {};
			testMessageInternal([1.1, "test", anObject], "equal to array [1.1, test, [object Object]]");
		}
		
		public function testMessage_Empty() : void
		{
			testMessageInternal([], "equal to array []");
		}

		private function testEvalInternal(compareArray : Array, evalObject : Object, expectedResult : Boolean) : void
		{
			var arrayEquals : ArrayEquals = new ArrayEquals(compareArray);
			
			var result : Boolean = arrayEquals.eval(evalObject);
			
			assertEquals("Unexpected eval result", expectedResult, result);
		}
		
		private function testMessageInternal(compareArray : Array, expectedMessage : String) : void
		{
			var arrayEquals : ArrayEquals = new ArrayEquals(compareArray);
			
			var message : String = arrayEquals.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}