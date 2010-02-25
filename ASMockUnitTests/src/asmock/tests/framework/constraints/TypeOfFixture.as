package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.TypeOf;
	import asmock.tests.ExtendedTestCase;
	
	import flash.utils.*;
	
	public class TypeOfFixture extends ExtendedTestCase
	{
		public function TypeOfFixture()
		{
		}
		
		public function testCtor_NullClass() : void
		{
			assertError(null, function():void
			{
				new TypeOf(null);
			}, ArgumentError);
		}
		
		public function testEval_SameClass() : void
		{
			testEvalInternal(ChildClass, new ChildClass(), true);
		}
		
		public function testEval_SuperClass() : void
		{
			testEvalInternal(BaseClass, new ChildClass(), true);
		}
		
		public function testEval_ImplementedInterface() : void
		{
			testEvalInternal(ITestInterfaceB, new ChildClass(), true);
		}
		
		public function testEval_SuperImplementedInterface() : void
		{
			testEvalInternal(ITestInterfaceA, new ChildClass(), true);
		}
		
		public function testEval_Object() : void
		{
			testEvalInternal(Object, new ChildClass(), true);
		}
		
		public function testEval_NonImplementedInterface() : void
		{
			testEvalInternal(ITestInterfaceC, new ChildClass(), false);
		}
		
		public function testEval_UnrelatedClass() : void
		{
			testEvalInternal(UnrelatedClass, new ChildClass(), false);
		}
		
		public function testMessage() : void
		{
			var className : String = getQualifiedClassName(ChildClass);
			
			testMessageInternal(ChildClass, "type of {" + className + "}");
		}
		
		private function testEvalInternal(cls : Class, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : TypeOf = new TypeOf(cls);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(cls : Class, expectedMessage : String) : void
		{
			var constraint : TypeOf = new TypeOf(cls);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}

	}
}

interface ITestInterfaceA
{
}

interface ITestInterfaceB
{
}

interface ITestInterfaceC
{
}

class BaseClass implements ITestInterfaceA
{
}

class ChildClass extends BaseClass implements ITestInterfaceB
{
}

class UnrelatedClass
{
}