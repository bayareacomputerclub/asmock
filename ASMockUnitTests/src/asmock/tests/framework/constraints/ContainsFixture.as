package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.Contains;
	import asmock.tests.ExtendedTestCase;
	
	public class ContainsFixture extends ExtendedTestCase
	{
		public function ContainsFixture()
		{
		}
		
		public function testCtor_NullString() : void
		{
			assertError(null, function():void
			{
				new Contains(null);
			}, ArgumentError);
		}
		
		public function testCtor_EmptyString() : void
		{
			assertError(null, function():void
			{
				new Contains("");
			}, ArgumentError);
		}
		
		public function testEval_TrueStart() : void
		{
			testEvalInternal("te", "test", true);
		}
		
		public function testEval_TrueMiddle() : void
		{
			testEvalInternal("es", "test", true);
		}
		
		public function testEval_TrueEnd() : void
		{
			testEvalInternal("st", "test", true);
		}
		
		public function testEval_False() : void
		{
			testEvalInternal("as", "test", false);
		}
		
		public function testEval_Null() : void
		{
			testEvalInternal("as", null, false);
		}
		
		public function testEval_Empty() : void
		{
			testEvalInternal("as", "", false);
		}
		
		public function testEval_Object() : void
		{
			testEvalInternal("es", {toString:function():String { return "test"; }}, true);
		}
		
		public function testMessage() : void
		{
			testMessageInternal("test \"value\"", "contains \"test \"value\"\"");
		}
		
		private function testEvalInternal(innerString : String, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : Contains = new Contains(innerString);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}
		
		private function testMessageInternal(innerString : String, expectedMessage : String) : void
		{
			var constraint : Contains = new Contains(innerString);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}

	}
}