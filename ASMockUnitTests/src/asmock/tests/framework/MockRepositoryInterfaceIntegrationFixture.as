package asmock.tests.framework
{
	import asmock.framework.Expect;
	import asmock.framework.ExpectationViolationError;
	import asmock.framework.OriginalCallOptions;
	import asmock.framework.SetupResult;
	
	import asmock.framework.asmock_internal;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.*;
	
	/**
	 * Contains integration tests for the framework in general.
	 * @author Richard Szalay
	 */	
	public class MockRepositoryInterfaceIntegrationFixture extends MockTestCase
	{
		public function MockRepositoryInterfaceIntegrationFixture()
		{
			super([IReferenceInterface]);
		}
		
		public function testMethodNotClosed() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			reference.methodInt(0);
			
			assertError(null, function():void
			{
				reference.methodInt(1);
			}, IllegalOperationError);
		}
		
		public function testUnordered() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			Expect.call(reference.methodInt(4)).returnValue(4);
			Expect.call(reference.methodInt(5)).returnValue(5);
			Expect.call(reference.methodVoid());
			Expect.call(reference.stringProperty).returnValue("test");
			mockRepository.replay(reference);
			
			reference.methodInt(5);
			var prop : String = reference.stringProperty;
			reference.methodInt(4);
			reference.methodVoid();
			
			mockRepository.verify(reference);
		}
		
		public function testUnordered_Fail() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			Expect.call(reference.methodInt(4)).returnValue(4);
			Expect.call(reference.methodInt(5)).returnValue(5);
			Expect.call(reference.methodVoid());
			Expect.call(reference.stringProperty).returnValue("test");
			mockRepository.replay(reference);
			
			reference.methodInt(5);
			var prop : String = reference.stringProperty;
			reference.methodInt(4);
			
			assertError(null, function():void
			{
				mockRepository.verify(reference);
			}, ExpectationViolationError);
		}
		
		public function testOrdered() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.ordered(function():void
			{
				Expect.call(reference.methodInt(4)).returnValue(4);
				Expect.call(reference.methodInt(5)).returnValue(5);
				Expect.call(reference.methodVoid());
				Expect.call(reference.stringProperty).returnValue("test");
			});
			mockRepository.replay(reference);
			
			reference.methodInt(4);
			reference.methodInt(5);
			reference.methodVoid();
			var prop : String = reference.stringProperty;
			
			mockRepository.verify(reference);
		}
		
		public function testOrdered_Fail() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.ordered(function():void
			{
				Expect.call(reference.methodInt(4)).returnValue(4);
				Expect.call(reference.methodInt(5)).returnValue(5);
				Expect.call(reference.methodVoid());
				Expect.call(reference.stringProperty).returnValue("test");
			});
			
			mockRepository.replay(reference);
			
			reference.methodInt(4);
			reference.methodInt(5);
			
			assertError(null, function():void
			{
				var prop : String = reference.stringProperty;
			}, ExpectationViolationError);
		}
		
		public function testMixedOrderedUnordered() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.ordered(function():void
			{
				Expect.call(reference.methodInt(4)).returnValue(4);
				
				mockRepository.unordered(function():void
				{
					Expect.call(reference.methodInt(5)).returnValue(5);
					Expect.call(reference.methodVoid());
				});
				
				Expect.call(reference.stringProperty).returnValue("test");
			});
			
			mockRepository.replay(reference);
			
			reference.methodInt(4);
			
			// unordered replayed in reverse order
			reference.methodVoid();
			reference.methodInt(5);
			
			var prop : String = reference.stringProperty;
			
			mockRepository.verify(reference);
		}
		
		public function testMixedOrderedUnordered_Fail() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.ordered(function():void
			{
				Expect.call(reference.methodInt(4)).returnValue(4);
				
				mockRepository.unordered(function():void
				{
					Expect.call(reference.methodInt(5)).returnValue(5);
					Expect.call(reference.methodVoid());
				});
				
				Expect.call(reference.stringProperty).returnValue("test");
			});
			
			mockRepository.replay(reference);
			
			reference.methodInt(4);
			
			// unordered replayed in reverse order
			reference.methodVoid();
			
			// Unordered expectations have not been statisfied 
			assertError(null, function():void
			{
				var prop : String = reference.stringProperty;
			}, ExpectationViolationError);
			
			assertError(null, function():void
			{
				mockRepository.verify(reference);
			}, ExpectationViolationError);
		}
		
		public function testSetupResultProperty() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			SetupResult.forCall(reference.stringProperty).returnValue("test");
			mockRepository.replayAll();
			
			assertEquals("Unexpected return value", "test", reference.stringProperty);
		}
		
		public function testCallOriginalMethod() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			Expect.call(reference.methodInt(2)).callOriginalMethod();
			mockRepository.replay(reference);
			
			assertError(null, function():void
			{
				assertEquals("Unexpected return value", 4, reference.methodInt(3));
			}, IllegalOperationError);
		}
		
		public function testCallOriginalMethodWithExpectation() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			Expect.call(reference.methodInt(2)).callOriginalMethod(OriginalCallOptions.CREATE_EXPECTATION)
				.repeat.twice();
			mockRepository.replay(reference);
			
			assertError(null, function():void
			{
				reference.methodInt(3);
			}, ExpectationViolationError);
			
			assertError(null, function():void
			{
				reference.methodInt(2);
			}, IllegalOperationError);
		}
		
		public function testReturnNull() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			Expect.call(reference.stringProperty).returnValue(null);
			mockRepository.replay(reference);
			
			assertNull(reference.stringProperty);
		}
		
		public function testDispatchEvent() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.stubEvents(reference);
			
			var eventToDispatch : Event = new Event("test", false, false);
			
			Expect.call(reference.methodVoid()).dispatchEvent(eventToDispatch);
			
			mockRepository.replay(reference);
			
			assertEvent(null, function():void
			{
				reference.methodVoid();
			}, reference, "test", null, 1);
		}
		
		public function testBackToRecord() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			Expect.call(reference.methodInt(1)).returnValue(1);
			mockRepository.backToRecord(reference);
			
			Expect.call(reference.methodInt(2)).returnValue(2);
			mockRepository.replay(reference);
			
			assertEquals(2, reference.methodInt(2));
		}
		
		public function testReplayInOrdered() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			Expect.call(reference.methodVoid());
			
			assertError(null, function():void
			{
				mockRepository.ordered(function():void				
				{
					mockRepository.replay(reference);
				});
			}, IllegalOperationError);
		}
		
		public function test_isPropertyStubbed_propertyNotStubbed_returnsFalse() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			var actualValue : Boolean = mockRepository.isPropertyStubbed(reference, "stringProperty");
			
			assertFalse(actualValue);
		}
		
		public function test_isPropertyStubbed_propertyStubbed_returnsTrue() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.stubProperty(reference.stringProperty);
			
			var actualValue : Boolean = mockRepository.isPropertyStubbed(reference, "stringProperty");
			
			assertTrue(actualValue);
		}
		
		public function test_getMockProperty_propertyNotStubbed_returnsNull() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			var actualValue : String = mockRepository.asmock_internal::getMockProperty(reference, "stringProperty") as String;
			
			assertNull(actualValue);
		}
		
		public function test_getMockProperty_propertyNotSet_returnsNull() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.stubProperty(reference.stringProperty);
			
			var actualValue : String = mockRepository.asmock_internal::getMockProperty(reference, "stringProperty") as String;
			
			assertNull(actualValue);
		}
		
		public function test_getMockProperty_propertySet_returnsSetValue() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.stubProperty(reference.stringProperty);
			
			var valueToSet : String = "sampleValue";
			
			mockRepository.asmock_internal::setMockProperty(reference, "stringProperty", valueToSet);
			
			var actualValue : String = mockRepository.asmock_internal::getMockProperty(reference, "stringProperty") as String;
			
			assertEquals(valueToSet, actualValue);
		}
		
		public function test_methodCall_stubbedProperties_doNotCallMockState() : void
		{
			// use strict so it will throw an ExpectationViolationError 
			// if this test fails
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			mockRepository.stubProperty(reference.stringProperty);
			mockRepository.replay(reference);
			
			var expectedValue : String = "sample value";
			
			reference.stringProperty = expectedValue;
			
			var actualValue : String = reference.stringProperty;
			
			assertEquals(expectedValue, actualValue); 
		}
		
		public function test_stubPropertyByName_invalidProperty_throwsError() : void
		{
			// use strict so it will throw an ExpectationViolationError 
			// if this test fails
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStrict(IReferenceInterface));
			
			assertError(null, function():void
			{
				mockRepository.stubPropertyByName(reference, "invalidProperty");
			}, ArgumentError);
			
		}
		
		public function test_createStub_stubOptionsProperties_stubsProperties() : void
		{
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStub(IReferenceInterface, StubOptions.PROPERTIES));

			mockRepository.replay(reference);
			
			var expectedValue : String = "sample value";
			
			reference.stringProperty = expectedValue;
			
			var actualValue : String = reference.stringProperty;
			
			assertEquals(expectedValue, actualValue); 
		}
		
		public function test_createStub_stubOptionsEvents_stubsEvents() : void
		{
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStub(IReferenceInterface, StubOptions.EVENTS));

			mockRepository.replay(reference);
			
			assertEvent(null, function() : void 
			{
				reference.dispatchEvent(new Event("test"));
			}, reference, "test"); 
		}
		
		public function test_createStub_stubOptionsNone_doesNotStubProperties() : void
		{
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStub(IReferenceInterface, StubOptions.NONE));
			
			mockRepository.replay(reference);
			
			var setValue : String = "sample value";
			
			reference.stringProperty = setValue;
			
			var actualValue : String = reference.stringProperty;
			
			assertNull(actualValue);
		}
		
		public function test_stubProperty_propertyAlreadyStubbed_throwsError() : void
		{
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStrict(IReferenceInterface));

			mockRepository.stubProperty(reference.stringProperty);
			
			assertError(null, function():void
			{
				mockRepository.stubProperty(reference.stringProperty);
			}, IllegalOperationError);
		}
		
		public function test_stubProperties_stubsAllProperties() : void
		{
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStrict(IReferenceInterface));

			mockRepository.stubAllProperties(reference);
			mockRepository.replay(reference);
			
			var expectedValue : String = "sample value";
			
			reference.stringProperty = expectedValue;
			
			var actualValue : String = reference.stringProperty;
			
			assertEquals(expectedValue, actualValue);
		}
		
		public function test_stubProperties_propertyAlreadyStubbed_propertyNotStubbedAgain() : void
		{
			var reference : IReferenceInterface = 
				IReferenceInterface(mockRepository.createStrict(IReferenceInterface));

			mockRepository.stubProperty(reference.stringProperty);
			mockRepository.stubAllProperties(reference);
			mockRepository.replay(reference);
			
			var expectedValue : String = "sample value";
			
			reference.stringProperty = expectedValue;
			
			var actualValue : String = reference.stringProperty;
			
			assertEquals(expectedValue, actualValue);
		}
		
		public function test_createDynamic_forInterface_throwsError() : void
		{
			assertError(null, function():void
			{
				mockRepository.createDynamic(IReferenceInterface);
			}, ArgumentError);
		}
	}
}
