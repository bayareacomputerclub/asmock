package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.framework.constraints.Not;
	import asmock.framework.constraints.Property;
	import asmock.framework.constraints.PropertyConstraint;
	import asmock.framework.constraints.PropertyIs;
	import asmock.tests.ExtendedTestCase;
	
	/**
	 * This fixture tests a static helper class, so the 
	 * tests just ensure the class returned is correct and also 
	 * provides simple pass/fail eval parameters to ensure any
	 * parameters were passed through correctly.
	 */
	public class PropertyFixture extends ExtendedTestCase
	{
		public function PropertyFixture()
		{
		}
		
		public function testIsNotNull() : void
		{
			testEval(Property.isNotNull("test"), Not, {test:"asd"}, {test:null});
		}
		
		public function testIsNull() : void
		{
			testEval(Property.isNull("test"), PropertyIs, {test:null}, {test:"asd"});
		}
		
		public function testValue() : void
		{
			testEval(Property.value("test", "asd"), PropertyIs, {test:"asd"}, {test:null});
		}
		
		public function testValueConstraint() : void
		{
			var constraint : MockConstraint = new MockConstraint();
			constraint.mock.setupProxy("eval", function(val : Boolean) : Boolean
			{
				return val;
			});
			
			testEval(Property.valueConstraint("test", constraint), PropertyConstraint, {test:true}, {test:false});
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