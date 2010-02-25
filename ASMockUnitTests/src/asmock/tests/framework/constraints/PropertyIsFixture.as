package asmock.tests.framework.constraints
{
	import asmock.framework.constraints.PropertyConstraint;
	import asmock.framework.constraints.PropertyIs;
	import asmock.tests.ExtendedTestCase;
	
	import flash.events.Event;

	public class PropertyIsFixture extends ExtendedTestCase
	{
		public function PropertyIsFixture()
		{
			super();
		}
		
		public function testCtor_NullPropertyName() : void
		{
			assertError(null, function():void
			{
				new PropertyIs(null, null);
			}, ArgumentError);
		}
		
		public function testCtor_EmptyPropertyName() : void
		{
			assertError(null, function():void
			{
				new PropertyIs("", null);
			}, ArgumentError);
		}
		
		public function testCtor_NullValue() : void
		{
			new PropertyIs("test", null);
		}
		
		public function testEval() : void
		{
			var event : Event = new Event(Event.COMPLETE);
			
			testEvalInternal("type", Event.COMPLETE, event, true);
		}
		
		public function testEval_False() : void
		{
			var event : Event = new Event(Event.COMPLETE);
			
			testEvalInternal("type", "test", event, false);
		}
		
		public function testEval_DynamicObject() : void
		{
			var obj : Object = {type:"test"};
			
			testEvalInternal("type", "test", obj, true);
		}
		
		public function testEval_InvalidProperty() : void
		{
			var event : Event = new Event(Event.COMPLETE);
			
			testEvalInternal("eventType", Event.COMPLETE, event, false);
		}
		
		public function testEval_InvalidProperty_DynamicObject() : void
		{
			var obj : Object = {type:"test"};
			
			testEvalInternal("eventType", null, obj, true);
		}
		
		public function testMessage() : void
		{
			testMessageInternal("testProperty", "testValue", "property 'testProperty' equal to testValue");
		}
		
		private function testEvalInternal(propertyName : String, value : Object, evalObject : Object, expectedResult : Boolean) : void
		{
			var constraint : PropertyIs = new PropertyIs(propertyName, value);
			
			var result : Boolean = constraint.eval(evalObject);
			
			assertEquals("Unexpected result", expectedResult, result);
		}

		private function testMessageInternal(propertyName : String, value : Object, expectedMessage : String) : void
		{
			var constraint : PropertyIs = new PropertyIs(propertyName, value);
			
			var message : String = constraint.message;
			
			assertEquals("Unexpected message value", expectedMessage, message);
		}
		
	}
}