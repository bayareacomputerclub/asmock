package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.And;
	import asmock.tests.ExtendedTestCase;

	public class AndFixture extends ExtendedTestCase
	{
		public function AndFixture()
		{
			super();
		}
		
		public function testCtor_NullConstraints() : void
		{
			assertError(null, function():void
			{
				new And(null);
			}, ArgumentError);
		}
		
		public function testCtor_ZeroConstraints() : void
		{
			assertError(null, function():void
			{
				new And([]);
			}, ArgumentError);
		}
		
		public function testCtor_NullConstraint() : void
		{
			assertError(null, function():void
			{
				new And([new MockConstraint(), null]);
			}, ArgumentError);
		}
		
		public function testCtor_NotConstraint() : void
		{
			assertError(null, function():void
			{
				new And([{}, {}]);
			}, ArgumentError);
		}
		
		public function testCtor_OneConstraint() : void
		{
			assertError(null, function():void
			{
				new And([new MockConstraint()]);
			}, ArgumentError);
		}
		
		public function testEval_FalseFirst() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("eval", false);
			
			var and : And = new And([constraintA, constraintB, constraintC]);
			
			var result : Boolean = and.eval(null);
			assertFalse("Unexpected return value", result);
		}
		
		public function testEval_FalseLast() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("eval", true);
			constraintB.mock.setupResult("eval", true);
			constraintC.mock.setupResult("eval", false);
			
			var and : And = new And([constraintA, constraintB, constraintC]);
			
			var result : Boolean = and.eval(null);
			assertFalse("Unexpected return value", result);
		}
		
		public function testEval_True() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("eval", true);
			constraintB.mock.setupResult("eval", true);
			constraintC.mock.setupResult("eval", true);
			
			var and : And = new And([constraintA, constraintB, constraintC]);
			
			var result : Boolean = and.eval(null);
			assertTrue("Unexpected return value", result);
		}
		
		public function testMessage() : void
		{
			var constraintA : MockConstraint = new MockConstraint();
			var constraintB : MockConstraint = new MockConstraint();
			var constraintC : MockConstraint = new MockConstraint();
			
			constraintA.mock.setupResult("message", "test A");
			constraintB.mock.setupResult("message", "test B");
			constraintC.mock.setupResult("message", "test C");
			
			var and : And = new And([constraintA, constraintB, constraintC]);
			
			var message : String = and.message;
			assertEquals("Unexpected message value", "(test A) and (test B) and (test C)", message);
		}
	}
}