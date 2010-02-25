package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.Like;
	import asmock.tests.ExtendedTestCase;
	
	public class LikeFixture extends ExtendedTestCase
	{
		public function LikeFixture()
		{
		}
		
		public function testCtor_Null() : void
		{
			assertError(null, function():void
			{
				new Like(null);
			}, ArgumentError);
		}
		
		public function testEval_String_Pass() : void
		{
			testEvalInternal(/^tes/, "test", true);
		}
		
		public function testEval_Number() : void
		{
			testEvalInternal(/^[\d\.]+$/, 1.2345, true);
		}
		
		public function testEval_String_Fail() : void
		{
			testEvalInternal(/tes$/, "test", false);
		}
		
		public function testEval_Object() : void
		{
			testEvalInternal(/^\[.+\]$/, {}, true);
		}
		
		public function testEval_ObjectToString() : void
		{
			function toStringFunction() : String
			{
				return "testObject";
			}
			
			testEvalInternal(/^testObject$/, {toString:toStringFunction}, true);
		}
		
		public function testMessage_Inline() : void
		{
			testMessageInternal(/^[\.]$/, "like \"^[\\.]$\"");
		}
		
		public function testMessage_Object() : void
		{
			testMessageInternal(new RegExp("^[\\\"]$"), "like \"^[\\\"]$\"");
		}

		private function testEvalInternal(expr : RegExp, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : Like = new Like(expr);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(expr : RegExp, expectedMessage : String) : void
		{
			var constraint : Like = new Like(expr);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}