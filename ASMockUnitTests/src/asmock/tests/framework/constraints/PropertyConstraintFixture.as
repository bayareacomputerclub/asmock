package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.AbstractConstraint;
	import asmock.framework.constraints.PropertyConstraint;
	import asmock.tests.ExtendedTestCase;
	
	import flash.events.Event;

	public class PropertyConstraintFixture extends ExtendedTestCase
	{
		public function PropertyConstraintFixture()
		{
			super();
		}
		
		public function testCtor_NullPropertyName() : void
		{
			assertError(null, function():void
			{
				new PropertyConstraint(null, new MockConstraint());
			}, ArgumentError);
		}
		
		public function testCtor_EmptyPropertyName() : void
		{
			assertError(null, function():void
			{
				new PropertyConstraint("", new MockConstraint());
			}, ArgumentError);
		}
		
		public function testCtor_NullConstraint() : void
		{
			assertError(null, function():void
			{
				new PropertyConstraint("test", null);
			}, ArgumentError);
		}
		
		public function testEval() : void
		{
			var event : Event = new Event(Event.COMPLETE);
			
			testEvalInternal("type", event, Event.COMPLETE, true, true);
		}
		
		public function testEval_DynamicObject() : void
		{
			var obj : Object = {type:"test"};
			
			testEvalInternal("type", obj, "test", true, false);
		}
		
		public function testEval_InvalidProperty() : void
		{
			var event : Event = new Event(Event.COMPLETE);
			
			testEvalInternal("eventType", event, Event.COMPLETE, false, false);
		}
		
		public function testEval_InvalidProperty_DynamicObject() : void
		{
			var obj : Object = {type:"test"};
			
			testEvalInternal("eventType", obj, null, true, false);
		}
		
		public function testEval_NullObject() : void
		{
			testEvalInternal("eventType", null, null, false, false);
		}
		
		public function testEval_OtherError() : void
		{
			var error : Error = new Error("Test error", 5);
			
			var obj : ThrowErrorObject = new ThrowErrorObject(error);
			
			assertError(null, function():void
			{
				testEvalInternal("property", obj, null, false, false);
			}, null, "Test error", [5]);
		}
		
		public function testMessage() : void
		{
			var mockConstraint : MockConstraint = new MockConstraint();
			mockConstraint.mock.setupResult("message", "test message");
			
			testMessageInternal("testProperty", mockConstraint, "property 'testProperty' test message");
		}
		
		private function testEvalInternal(propertyName : String, evalObject : Object, expectedArgument : Object, expectCall : Boolean, returnResult : Boolean) : void
		{
			var constraintCalled : Boolean = false;
			var actualArgument : Object = null;
			
			var mockConstraint : MockConstraint = new MockConstraint();
			
			if (expectCall)
			{
				mockConstraint.mock.setupProxy("eval", function(obj : Object) : Boolean
				{
					constraintCalled = true;
					actualArgument = obj;
					
					return returnResult;
				});
			}
			
			var constraint : PropertyConstraint = new PropertyConstraint(propertyName, mockConstraint);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", returnResult, result);
			
			if (expectCall)
			{
				assertTrue("Expected inner constraint to be called", constraintCalled);
				assertEquals("Unexpected argument passed to constraint", expectedArgument, actualArgument);
			}
		}

		private function testMessageInternal(propertyName : String, innerConstraint : AbstractConstraint, expectedMessage : String) : void
		{
			var constraint : PropertyConstraint = new PropertyConstraint(propertyName, innerConstraint);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
		
	}
}

class ThrowErrorObject
{
	private var _errorToThrow : Error;
	
	public function ThrowErrorObject(error : Error)
	{
		_errorToThrow = error;
	}
	
	public function get property() : String
	{
		throw _errorToThrow; 
	}
}
