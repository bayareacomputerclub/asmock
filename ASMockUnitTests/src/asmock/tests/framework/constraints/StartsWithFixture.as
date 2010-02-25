package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.EndsWith;
	import asmock.framework.constraints.StartsWith;
	import asmock.tests.ExtendedTestCase;
	
	public class StartsWithFixture extends ExtendedTestCase
	{
		public function StartsWithFixture()
		{
		}
		
		public function testCtor_NullString() : void
		{
			assertError(null, function():void
			{
				new StartsWith(null);
			}, ArgumentError);
		}
		
		public function testCtor_EmptyString() : void
		{
			assertError(null, function():void
			{
				new StartsWith("");
			}, ArgumentError);
		}
		
		public function testEval_True() : void
		{
			testEvalInternal("te", "test", true);
		}
		
		public function testEval_False() : void
		{
			testEvalInternal("st", "test", false);
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
			testEvalInternal("te", {toString:function():String { return "test"; }}, true);
		}
		
		public function testMessage() : void
		{
			testMessageInternal("test \"value\"", "starts with \"test \"value\"\"");
		}
		
		private function testEvalInternal(value : String, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : StartsWith = new StartsWith(value);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(value : String, expectedMessage : String) : void
		{
			var constraint : StartsWith = new StartsWith(value);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}