package asmock.tests.reflection
{
	import asmock.reflection.*;
	import asmock.tests.ExtendedTestCase;
	
	public class MethodInfoFixture extends ExtendedTestCase
	{
		public function MethodInfoFixture()
		{
		}
		
		public function test_getCallingMethod_returnsThisMethod() : void
		{
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			assertEquals("test_getCallingMethod_returnsThisMethod", method.name);
			assertEquals(Type.getType(MethodInfoFixture), method.owner);
		}
		
		public function test_getCallingMethod_fromNestedFunction_returnsOuterMethod() : void
		{
			function testFunction() : void
			{
				var method : MethodInfo = MethodInfo.getCallingMethod();
			
				assertEquals("test_getCallingMethod_fromNestedFunction_returnsOuterMethod", method.name);
				assertEquals(Type.getType(MethodInfoFixture), method.owner);
			}
			
			testFunction();
		}
		
		public function test_getCallingMethod_fromAnonymousFunction_returnsOuterMethod() : void
		{
			var func : Function = function() : void
			{
				var method : MethodInfo = MethodInfo.getCallingMethod();
			
				assertEquals("test_getCallingMethod_fromAnonymousFunction_returnsOuterMethod", method.name);
				assertEquals(Type.getType(MethodInfoFixture), method.owner);
			}
			
			func();
		}

	}
}