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
	public class MockRepositoryNestedClassIntegrationFixture extends MockTestCase
	{
		public function MockRepositoryNestedClassIntegrationFixture()
		{
			super([NestedClass]);
		}
		
		public function testMissingArgument() : void
		{
			assertError(null, function():void
			{
				var reference : IReferenceInterface = IReferenceInterface(mockRepository.create(NestedClass));
			}, ArgumentError);
		}
		
		public function testMissingOptionalArgument() : void
		{
			assertError(null, function():void
			{
				var reference : IReferenceInterface = IReferenceInterface(mockRepository.create(NestedClass, [1]));
			}, ArgumentError);
		}
		
		public function testMethodNotClosed() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.create(NestedClass, [1, null]));
			
			reference.methodInt(0);
			
			assertError(null, function():void
			{
				reference.methodInt(1);
			}, IllegalOperationError);
		}
		
		public function testUnordered() : void
		{
			var reference : NestedClass = NestedClass(mockRepository.create(NestedClass, [1, null]));
			
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
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.create(NestedClass, [1, null]));
			
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
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.create(NestedClass, [1, null]));
			
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
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.create(NestedClass, [1, null]));
			
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
		
		public function testSetupResultProperty() : void
		{
			var reference : IReferenceInterface = IReferenceInterface(mockRepository.create(NestedClass, [1, null]));
			
			SetupResult.forCall(reference.stringProperty).returnValue("test");
			mockRepository.replayAll();
			
			assertEquals("Unexpected return value", "test", reference.stringProperty);
		}
		
		public function testCallOriginalMethod() : void
		{
			var reference : NestedClass = NestedClass(mockRepository.create(NestedClass, [1, null]));
			
			SetupResult.forCall(reference.methodInt(2)).callOriginalMethod();
			mockRepository.replay(reference);
			
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
			assertEquals("Unexpected return value", 4, reference.methodInt(3));
		}
		
		public function testCallOriginalMethodWithExpectation() : void
		{
			var reference : NestedClass = NestedClass(mockRepository.create(NestedClass, [1, null]));
			
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
		
		public function testCallOriginalMethod_Property() : void
		{
			var reference : NestedClass = NestedClass(mockRepository.create(NestedClass, [1, null]));
			
			SetupResult.forCall(reference.stringProperty).callOriginalMethod(); 
			SetupResult.forCall(reference.stringProperty = null).callOriginalMethod();
			mockRepository.replay(reference);
			
			reference.stringProperty = "test";
			
			assertEquals("test", reference.stringProperty); 
		}
		
		public function testCallOriginalMethod_CallsOtherMethod() : void
		{
			var reference : NestedClass = NestedClass(mockRepository.create(NestedClass, [1, null]));
			
			// Call the base method, which then calls methodInt
			SetupResult.forCall(reference.methodVoid()).callOriginalMethod();
			SetupResult.forCall(reference.methodInt(0)).ignoreArguments().returnValue(1);
			
			mockRepository.replay(reference);
			
			reference.methodVoid();
			mockRepository.verify(reference);
		}
				
		public function testRest() : void
		{
			var reference : NestedClass = NestedClass(mockRepository.create(NestedClass, [1, null]));
			
			Expect.call(reference.methodRest("", 1, 2, 3)).callOriginalMethod();
			mockRepository.replay(reference);
			
			var expectedRestLength : int = 3;
			
			assertEquals(expectedRestLength, reference.methodRest("", 1, 2, 3));
			
		}
	}
}
	import asmock.tests.framework.ReferenceImplementation;

class NestedClass extends ReferenceImplementation
{
	public function NestedClass(requiredArg : int, optionalArg : String = null)
	{
		super(requiredArg, optionalArg);
	}
}

class NestedChild extends NestedClass
{
	public function NestedChild(requiredArg : int, optionalArg : String = null)
	{
		super(requiredArg, optionalArg);
	}
}