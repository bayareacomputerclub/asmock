package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.Equal;
	import asmock.tests.ExtendedTestCase;
	
	public class EqualFixture extends ExtendedTestCase
	{
		public function EqualFixture()
		{
		}
		
		public function testCtor_Null() : void
		{
			new Equal(null);
		}
		
		public function testEval_Null_True() : void
		{
			testEvalInternal(null, null, true);
		}
		
		public function testEval_Null_False() : void
		{
			testEvalInternal(null, "test", false);
		}
		
		public function testEval_String_True() : void
		{
			testEvalInternal("test", "test", true);
		}
		
		public function testEval_String_False() : void
		{
			testEvalInternal("test", "test2", false);
		}
		
		public function testEval_Number_True() : void
		{
			testEvalInternal(1.234, 1.234, true);
		}
		
		public function testEval_Number_False() : void
		{
			testEvalInternal(1.234, 1.235, false);
		}
		
		public function testEval_Object_True() : void
		{
			var anObject : Object = {};
			testEvalInternal(anObject, anObject, true);
		}
		
		public function testEval_Object_False() : void
		{
			var anObject : Object = {};
			testEvalInternal(anObject, {}, false);
		}
		
		public function testEval_Array_True() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], [1.0, "test", anObject], true);
		}
		
		public function testEval_Array_False() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], [1.0, "test", {}], false);
		}
		
		public function testMessage_String() : void
		{
			testMessageInternal("test \"value\"", "equal to test \"value\"");
		}
		
		public function testMessage_Object() : void
		{
			testMessageInternal({}, "equal to [object Object]");
		}
		
		public function testMessage_ObjectToString() : void
		{
			function toStringFunction() : String
			{
				return "testObject";
			}
			
			testMessageInternal({toString:toStringFunction}, "equal to testObject");
		}
		
		public function testMessage_Array() : void
		{
			testMessageInternal([1, 2, "test"], "equal to 1,2,test");
		}
		
		private function testEvalInternal(value : Object, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : Equal = new Equal(value);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(value : Object, expectedMessage : String) : void
		{
			var constraint : Equal = new Equal(value);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}