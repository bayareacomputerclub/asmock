package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.Contains;
	import asmock.framework.constraints.EndsWith;
	import asmock.tests.ExtendedTestCase;
	
	public class EndsWithFixture extends ExtendedTestCase
	{
		public function EndsWithFixture()
		{
		}
		
		public function testCtor_NullString() : void
		{
			assertError(null, function():void
			{
				new EndsWith(null);
			}, ArgumentError);
		}
		
		public function testCtor_EmptyString() : void
		{
			assertError(null, function():void
			{
				new EndsWith("");
			}, ArgumentError);
		}
		
		public function testEval_True() : void
		{
			testEvalInternal("st", "test", true);
		}
		
		public function testEval_False() : void
		{
			testEvalInternal("es", "test", false);
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
			testEvalInternal("st", {toString:function():String { return "test"; }}, true);
		}
		
		public function testMessage() : void
		{
			testMessageInternal("test \"value\"", "ends with \"test \"value\"\"");
		}
		
		private function testEvalInternal(value : String, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : EndsWith = new EndsWith(value);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(value : String, expectedMessage : String) : void
		{
			var constraint : EndsWith = new EndsWith(value);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}