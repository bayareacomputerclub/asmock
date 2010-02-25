package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.ListEquals;
	import asmock.tests.ExtendedTestCase;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;

	public class ListEqualsFixture extends ExtendedTestCase
	{
		public function ListEqualsFixture()
		{
			super();
		}
		
		public function testCtor_NullList() : void
		{
			assertError(null, function():void
			{
				new ListEquals(null);
			}, ArgumentError);
		}
		
		public function testCtor_EmptyList() : void
		{
			new ListEquals(new ArrayList());
		}
		
		public function testEval_Success() : void
		{
			var anObject : Object = {};
			testEvalInternal(new ArrayList([1.0, "test", anObject]), new ArrayList([1.0, "test", anObject]), true);
		}
		
		public function testEval_FailFirst() : void
		{
			var anObject : Object = {};
			testEvalInternal(new ArrayList([1.0, "test", anObject]), new ArrayList([1.1, "test", anObject]), false);
		}
		
		public function testEval_FailLast() : void
		{
			var anObject : Object = {};
			testEvalInternal(new ArrayList([1.0, "test", anObject]), new ArrayList([1.0, "test", null]), false);
		}
		
		public function testEval_FailDifferentLengths() : void
		{
			var anObject : Object = {};
			testEvalInternal(new ArrayList([1.0, "test", anObject]), new ArrayList([1.0, "test"]), false);
		}
		
		public function testEval_NotList() : void
		{
			var anObject : Object = {};
			testEvalInternal(new ArrayList([1.0, "test", anObject]), anObject, false);	
		}
		
		public function testEval_Array() : void
		{
			var anObject : Object = {};
			testEvalInternal(new ArrayList([1.0, "test", anObject]), [1.0, "test", anObject], false);
		}
		
		public function testEval_Null() : void
		{
			var anObject : Object = {};
			testEvalInternal(new ArrayList([1.0, "test", anObject]), null, false);
		}
		
		public function testMessage() : void
		{
			var anObject : Object = {};
			testMessageInternal(new ArrayList([1.1, "test", anObject]), "equal to list [1.1, test, [object Object]]");
		}
		
		public function testMessage_Empty() : void
		{
			testMessageInternal(new ArrayList([]), "equal to list []");
		}
		
		private function testEvalInternal(compareList : IList, evalObject : Object, expectedResult : Boolean) : void
		{
			var arrayEquals : ListEquals = new ListEquals(compareList);
			
			var result : Boolean = arrayEquals.eval(evalObject);
			
			assertEquals("Unexpected eval result", expectedResult, result);
		}
		
		private function testMessageInternal(compareList : IList, expectedMessage : String) : void
		{
			var arrayEquals : ListEquals = new ListEquals(compareList);
			
			var message : String = arrayEquals.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
	}
}