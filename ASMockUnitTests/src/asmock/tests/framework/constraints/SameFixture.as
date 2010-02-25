package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.Equal;
	import asmock.framework.constraints.Same;
	import asmock.tests.ExtendedTestCase;
	
	public class SameFixture extends ExtendedTestCase
	{
		public function SameFixture()
		{
		}
		
		public function testCtor_Null() : void
		{
			new Same(null);
		}
		
		public function testEval_Null_True() : void
		{
			testEvalInternal(null, null, true);
		}
		
		public function testEval_Null_False() : void
		{
			testEvalInternal(null, "test", false);
		}
		
		public function testEval_String() : void
		{
			var strA : String = "test";
			var strB : String = strA;
			
			testEvalInternal(strA, strB, true);
		}
		
		public function testEval_InternedString() : void
		{
			var strA : String = "test";
			var strB : String = "test";
			
			testEvalInternal(strA, strB, true);
		}
		
		public function testEval_InternedNumber() : void
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
			testEvalInternal([1.0, "test", anObject], [1.0, "test", anObject], false);
		}
		
		public function testEval_Array_False() : void
		{
			var anObject : Object = {};
			testEvalInternal([1.0, "test", anObject], [1.0, "test", {}], false);
		}
		
		public function testMessage_String() : void
		{
			testMessageInternal("test \"value\"", "same as test \"value\"");
		}
		
		public function testMessage_Object() : void
		{
			testMessageInternal({}, "same as [object Object]");
		}
		
		public function testMessage_ObjectToString() : void
		{
			function toStringFunction() : String
			{
				return "testObject";
			}
			
			testMessageInternal({toString:toStringFunction}, "same as testObject");
		}
		
		public function testMessage_Array() : void
		{
			testMessageInternal([1, 2, "test"], "same as 1,2,test");
		}
		
		private function testEvalInternal(value : Object, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : Same = new Same(value);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(value : Object, expectedMessage : String) : void
		{
			var constraint : Same = new Same(value);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}