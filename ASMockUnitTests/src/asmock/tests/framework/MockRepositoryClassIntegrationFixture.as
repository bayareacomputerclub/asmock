package asmock.tests.framework
{
	import asmock.framework.Expect;
	import asmock.framework.ExpectationViolationError;
	import asmock.framework.OriginalCallOptions;
	import asmock.framework.SetupResult;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.*;
	
	/**
	 * Contains integration tests for the framework in general.
	 * @author Richard Szalay
	 */	
	public class MockRepositoryClassIntegrationFixture extends MockTestCase
	{
		public function MockRepositoryClassIntegrationFixture()
		{
			super([ReferenceImplementation, ChildReferenceImplementation]);
		}
		
		public function test_createStrict_missingCtorArgument_throwsError() : void
		{
			assertError(null, function():void
			{
				var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(ReferenceImplementation));
			}, ArgumentError);
		}
		
		public function test_createStrict_missingCtorOptionalArgument_supported() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(ReferenceImplementation, [1]));
		}
		
		public function test_mockCall_previousCallNotClosed_throwsError() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
			reference.methodInt(0);
			
			assertError(null, function():void
			{
				reference.methodInt(1);
			}, IllegalOperationError);
		}
		
		public function test_unordered_noMissingCalls_succeeds() : void
		{
			var reference : ReferenceImplementation = ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
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
		
		public function test_unordered_missingCalls_throwsError() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
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
		

		public function test_ordered_noMissingCalls_succeeds() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
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
		
		public function test_ordered_callsReplayedInIncorrectOrder_throwsError() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
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
		
		public function test_setupResult_onProperty_returnsMockedValue() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
			SetupResult.forCall(reference.stringProperty).returnValue("test");
			mockRepository.replayAll();
			
			assertEquals("Unexpected return value", "test", reference.stringProperty);
		}
		
		public function test_callOriginalMethod_whenReplayed_callsBaseMethod() : void
		{
			var reference : ReferenceImplementation = ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
			SetupResult.forCall(reference.methodInt(2)).callOriginalMethod();
			mockRepository.replay(reference);
			
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
		}
		
		public function test_callOriginalMethod_withExpectation_notCalled_throwsError() : void
		{
			var reference : ReferenceImplementation = ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
			SetupResult.forCall(reference.methodInt(2)).callOriginalMethod(OriginalCallOptions.CREATE_EXPECTATION)
				.repeat.twice();
			mockRepository.replay(reference);
			
			assertError(null, function():void
			{
				reference.methodInt(3);
			}, ExpectationViolationError);
			
			assertEquals("Unexpected return value", 3, reference.methodInt(2));
			assertEquals("Unexpected return value", 3, reference.methodInt(2));
			
			mockRepository.verify(reference);
		}
		
		public function test_callOriginalMethod_onProperty_callsBaseProperty() : void
		{
			var reference : ReferenceImplementation = ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
			SetupResult.forCall(reference.stringProperty).callOriginalMethod(); 
			SetupResult.forCall(reference.stringProperty = null).callOriginalMethod();
			mockRepository.replay(reference);
			
			reference.stringProperty = "test";
			
			assertEquals("test", reference.stringProperty); 
		}
		
		public function test_callOriginalMethod_whichCallsMockedMethod_returnsMockedReturnValue() : void
		{
			var reference : ReferenceImplementation = ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
			// Call the base method, which then calls methodInt
			SetupResult.forCall(reference.methodVoid()).callOriginalMethod();
			SetupResult.forCall(reference.methodInt(0)).ignoreArguments().returnValue(1);
			
			mockRepository.replay(reference);
			
			reference.methodVoid();
			mockRepository.verify(reference);
		}
		
		public function test_concreteClass_methodsCanBeMockedOnBaseClass() : void
		{
			var reference : ChildReferenceImplementation = ChildReferenceImplementation(mockRepository.createStrict(ChildReferenceImplementation, [1, null]));
			
			reference.anotherMethodVoid()
			reference.methodVoid()
			mockRepository.replay(reference);
			
			reference.anotherMethodVoid();
			reference.methodVoid();
			
			mockRepository.verify(reference);
						
		}
		
		public function test_expectCall_supportsStarType() : void
		{
			var reference : ChildReferenceImplementation = ChildReferenceImplementation(mockRepository.createStrict(ChildReferenceImplementation, [1, null]));
			
			Expect.call(reference.methodStar()).returnValue("test");
			mockRepository.replay(reference);
			
			assertEquals("test", reference.methodStar());
		}
		
		public function test_expectCall_supportsRestType() : void
		{
			var reference : ReferenceImplementation = ReferenceImplementation(mockRepository.createStrict(ReferenceImplementation, [1, null]));
			
			Expect.call(reference.methodRest("", 1, 2, 3)).callOriginalMethod();
			mockRepository.replay(reference);
			
			var expectedRestLength : int = 3;
			
			assertEquals(expectedRestLength, reference.methodRest("", 1, 2, 3));
		}
	}
}
