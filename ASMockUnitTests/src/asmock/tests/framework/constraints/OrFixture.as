package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.Or;
	import asmock.tests.ExtendedTestCase;

	public class OrFixture extends ExtendedTestCase
	{
		public function OrFixture()
		{
			super();
		}
		
		public function testCtor_NullConstraints() : void
		{
			assertError(null, function():void
			{
				new Or(null);
			}, ArgumentError);
		}
		
		public function testCtor_ZeroConstraints() : void
		{
			assertError(null, function():void
			{
				new Or([]);
			}, ArgumentError);
		}
		
		public function testCtor_NullConstraint() : void
		{
			assertError(null, function():void
			{
				new Or([new MockConstraint(), null]);
			}, ArgumentError);
		}
		
		public function testCtor_NotConstraint() : void
		{
			assertError(null, function():void
			{
				new Or([{}, {}]);
			}, ArgumentError);
		}
		
		public function testCtor_OneConstraint() : void
		{
			assertError(null, function():void
			{
				new Or([new MockConstraint()]);
			}, ArgumentError);
		}
		
		public function testEval_TrueFirst() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("eval", true);
			
			var or : Or = new Or([constraintA, constraintB, constraintC]);
			
			var result : Boolean = or.eval(null);
			assertTrue("Unexpected return value", result);
		}
		
		public function testEval_TrueLast() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("eval", false);
			constraintB.mock.setupResult("eval", false);
			constraintC.mock.setupResult("eval", true);
			
			var or : Or = new Or([constraintA, constraintB, constraintC]);
			
			var result : Boolean = or.eval(null);
			assertTrue("Unexpected return value", result);
		}
		
		public function testEval_False() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("eval", false);
			constraintB.mock.setupResult("eval", false);
			constraintC.mock.setupResult("eval", false);
			
			var or : Or = new Or([constraintA, constraintB, constraintC]);
			
			var result : Boolean = or.eval(null);
			assertFalse("Unexpected return value", result);
		}
		
		public function testMessage() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("message", "test A");
			constraintB.mock.setupResult("message", "test B");
			constraintC.mock.setupResult("message", "test C");
			
			var or : Or = new Or([constraintA, constraintB, constraintC]);
			
			var message : String = or.message;
			assertEquals("Unexpected message value", "(test A) or (test B) or (test C)", message);
		}
	}
}