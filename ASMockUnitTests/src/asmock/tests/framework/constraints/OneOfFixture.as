package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.OneOf;
	import asmock.tests.ExtendedTestCase;
	
	public class OneOfFixture extends ExtendedTestCase
	{
		public function OneOfFixture()
		{
		}
		
		public function testCtor_NullArray() : void
		{
			assertError(null, function():void
			{
				new OneOf(null);
			}, ArgumentError);
		}
		
		public function testCtor_EmptyArray() : void
		{
			assertError(null, function():void
			{
				new OneOf([]);
			}, ArgumentError);
		}
		
		public function testEval_First() : void
		{
			testEvalInternal(["test", "test2"], "test", true);
		}
		
		public function testEval_Last() : void
		{
			testEvalInternal(["test", "test2"], "test2", true);
		}
		
		public function testEval_Fail() : void
		{
			testEvalInternal(["test1", "test2"], "test", false);
		}
		
		public function testEval_Number_True() : void
		{
			testEvalInternal([1.234], 1.234, true);
		}
		
		public function testEval_Number_False() : void
		{
			testEvalInternal([1.234], 1.235, false);
		}
		
		public function testEval_Object_True() : void
		{
			var anObject : Object = {};
			testEvalInternal([anObject], anObject, true);
		}
		
		public function testEval_Object_False() : void
		{
			var anObject : Object = {};
			testEvalInternal([anObject], {}, false);
		}
		
		public function testEval_Object_ToString() : void
		{
			function toStringFunc() : String
			{
				return "testValue";
			}
			
			testEvalInternal(["testValue"], {toString:toStringFunc}, true);
		}
		
		public function testEval_Array() : void
		{
			var anObject : Object = {};
			testEvalInternal([[1.0, "test", anObject]], [1.0, "test", anObject], false);
		}
		
		public function testMessage() : void
		{
			var anObject : Object = {};
			testMessageInternal([1.1, "test", anObject], "one of [1.1, test, [object Object]]");
		}
		
		private function testEvalInternal(values : Array, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : OneOf = new OneOf(values);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(values : Array, expectedMessage : String) : void
		{
			var constraint : OneOf = new OneOf(values);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}