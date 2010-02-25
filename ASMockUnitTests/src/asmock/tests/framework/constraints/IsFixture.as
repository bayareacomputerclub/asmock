package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.framework.constraints.ComparingConstraint;
	import asmock.framework.constraints.Equal;
	import asmock.framework.constraints.Is;
	import asmock.framework.constraints.Not;
	import asmock.framework.constraints.PredicateConstraint;
	import asmock.framework.constraints.Same;
	import asmock.framework.constraints.TypeOf;
	import asmock.tests.ExtendedTestCase;
	
	/**
	 * This fixture tests a static helper class, so the 
	 * tests just ensure the class returned is correct and also 
	 * provides simple pass/fail eval parameters to ensure any
	 * parameters were passed through correctly.
	 */
	public class IsFixture extends ExtendedTestCase
	{
		public function IsFixture()
		{
		}
		
		public function testEqual() : void
		{
			testEval(Is.equal("value"), Equal, "value", "fail");
		}
		
		public function testGreaterThan() : void
		{
			testEval(Is.greaterThan(5), ComparingConstraint, 6, 5);
		}
		
		public function testGreaterThanOrEqual() : void
		{
			testEval(Is.greaterThanOrEqual(5), ComparingConstraint, 5, 4);
		}
		
		public function testLessThan() : void
		{
			testEval(Is.lessThan(5), ComparingConstraint, 4, 5);
		}
		
		public function testLessThanOrEqual() : void
		{
			testEval(Is.lessThanOrEqual(5), ComparingConstraint, 5, 6);
		}
		
		public function testMatching() : void
		{
			var objectA : Object = {};
			var objectB : Object = {};
			
			function matchFunction(obj : Object) : Boolean
			{
				return obj === objectA;
			}
			
			testEval(Is.matching(matchFunction), PredicateConstraint, objectA, objectB);
		}
		
		public function testNotEqual() : void
		{
			testEval(Is.notEqual("value"), Not, "fail", "value");
		}
		
		public function testNotNull() : void
		{
			testEval(Is.notNull(), Not, "value", null);
		}
		
		public function testNotSame() : void
		{
			var objectA : Object = {};
			var objectB : Object = {};
			
			testEval(Is.notSame(objectA), Not, objectB, objectA);
		}
		
		public function testIsNull() : void
		{
			testEval(Is.isNull(), Equal, null, "value");
		}
		
		public function testSame() : void
		{
			var objectA : Object = {};
			var objectB : Object = {};
			
			testEval(Is.same(objectA), Same, objectA, objectB);
		}
		
		public function testTypeOf() : void
		{
			testEval(Is.typeOf(String), TypeOf, "test", 5);
		}
		
		private function testEval(constraint : AbstractConstraint, constraintClass : Class, passEvalObject : Object, failEvalObject : Object) : void
		{
			assertTrue("Unexpected constraint type returned", constraint is constraintClass);
			
			var result : Boolean = constraint.eval(passEvalObject);
			assertTrue("Unexpected eval result", result);
			
			result = constraint.eval(failEvalObject);
			assertFalse("Unexpected eval result", result);
		}
	}
}