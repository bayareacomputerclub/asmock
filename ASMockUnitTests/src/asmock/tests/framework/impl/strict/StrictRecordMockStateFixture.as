package asmock.tests.framework.impl.strict
{
	import asmock.framework.IMethodOptions;
	import asmock.framework.expectations.ArgsEqualExpectation;
	import asmock.framework.expectations.IExpectation;
	import asmock.framework.impl.IMockState;
	import asmock.framework.impl.strict.StrictRecordMockState;
	import asmock.framework.impl.strict.StrictReplayMockState;
	import asmock.reflection.MethodInfo;
	import asmock.tests.ExtendedTestCase;
	import asmock.tests.framework.MockInvocation;
	import asmock.tests.framework.MockMethodRecorder;
	import asmock.tests.framework.MockMockRepository;
	import asmock.tests.framework.expectations.MockExpectation;
	
	import flash.errors.IllegalOperationError;

	public class StrictRecordMockStateFixture extends ExtendedTestCase
	{
		private var _mockObject : Object = new Object();
		private var _mockRepository : MockMockRepository = new MockMockRepository();
		
		public function StrictRecordMockStateFixture()
		{
			super();
		}
		
		public override function setUp():void
		{
			_mockRepository.mock.reset();
		}
		
		public function test_ctor_propertiesCorrectlyAssigned() : void
		{
			var state : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			assertStrictlyEquals("Unexpected repository property value", _mockRepository, state.repository);
			assertStrictlyEquals("Unexpected proxy property value", _mockObject, state.proxy);
			
			var expectation : IExpectation = new MockExpectation();
			
			state.lastExpectation = expectation;
			
			assertStrictlyEquals("lastExpectation not set correctly", expectation, state.lastExpectation);
		}
		
		public function test_methodCall_lastMethodNotClosed_throwsError() : void
		{
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [1, "two"];
			
			var mockExpectation : MockExpectation = new MockExpectation();
			var invocation : MockInvocation = new MockInvocation();
			var recorder : MockMethodRecorder = new MockMethodRecorder();
			
			var lastMockObject : Object;
			var recordArgs : Array;
			
			mockExpectation.mock.setupResult("actionsSatisfied", false);
			mockExpectation.mock.setupResult("get_errorMessage", "test error message");
			
			_mockRepository.mock.setupResult("recorder", recorder);
			_mockRepository.mock.setupProxy("set_lastMockedObject", function(obj:Object) : void { lastMockObject = obj; });
			
			recorder.mock.setupProxy("record", function(... args) : void { recordArgs = args; });
			
			var state : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			state.lastExpectation = mockExpectation;
			
			var error : Error = assertError(null, function():void
			{
				state.methodCall(invocation, method, args);
			}, IllegalOperationError);
			
			assertTrue("Unexpected error message", error.message.indexOf("test error message") > -1);
		}
		
		public function test_methodCall_lastMethodClosed_callsMethodRecorderRecord() : void
		{
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [1, "two"];
			
			var mockExpectation : MockExpectation = new MockExpectation();
			var invocation : MockInvocation = new MockInvocation();
			var recorder : MockMethodRecorder = new MockMethodRecorder();
			
			var lastMockObject : Object;
			var recordArgs : Array;
			
			mockExpectation.mock.setupResult("actionsSatisfied", true);
			
			_mockRepository.mock.setupResult("recorder", recorder);
			_mockRepository.mock.setupProxy("set_lastMockedObject", function(obj:Object) : void { lastMockObject = obj; });
			
			recorder.mock.setupProxy("record", function(... args) : void { recordArgs = args; });
			
			var state : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			state.lastExpectation = mockExpectation;
			state.methodCall(invocation, method, args);
			
			assertNotNull("Expected IMethodRecorder.record to be called", recordArgs);
			assertArrayEquals("Unexpected argument passed to IMethodRecorder.record", [_mockObject, method], recordArgs.slice(0, 2));
			assertTrue("Unexpected expectation passed to IMethodRecorder", recordArgs[2] is ArgsEqualExpectation);
		}
		
		public function test_methodCall_noLastMethod_throwsError() : void
		{
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var args : Array = [1, "two"];
			var invocation : MockInvocation = new MockInvocation();
			var recorder : MockMethodRecorder = new MockMethodRecorder();
			
			var lastMockObject : Object;
			var recordArgs : Array;
			
			_mockRepository.mock.setupResult("recorder", recorder);
			_mockRepository.mock.setupProxy("set_lastMockedObject", function(obj:Object) : void { lastMockObject = obj; });
			
			recorder.mock.setupProxy("record", function(... args) : void { recordArgs = args; });
			
			var state : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			state.methodCall(invocation, method, args);
			
			assertNotNull("Expected IMethodRecorder.record to be called", recordArgs);
			assertArrayEquals("Unexpected argument passed to IMethodRecorder.record", [_mockObject, method], recordArgs.slice(0, 2));
			assertTrue("Unexpected expectation passed to IMethodRecorder", recordArgs[2] is ArgsEqualExpectation);
		}
		
		public function testGetLastMethodOptions_HasExpectation() : void
		{
			var expectation : MockExpectation = new MockExpectation();
			
			var state : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			state.lastExpectation = expectation;
			
			var methodOptions : IMethodOptions = state.getLastMethodOptions();
			
			assertNotNull("Expected non-null result from getLastMethodOptions", methodOptions);
		}
		
		public function test_getLastMethodOptions_noExpectation_throwsError() : void
		{
			var state : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			assertError(null, function():void
			{
				state.getLastMethodOptions();
			}, IllegalOperationError);
		}
		
		public function test_verifyState_throwsError() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			assertError(null, function():void
			{
				var state : IMockState = recordState.verifyState;
			}, IllegalOperationError);
		}
		
		public function test_verify_alwaysThrowsError() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			assertError(null, function():void
			{
				recordState.verify();
			}, IllegalOperationError);
		}
		
		public function test_canVerify_alwaysThrowsError() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			assertError(null, function():void
			{
				var canVerify : Boolean = recordState.canVerify;
			}, IllegalOperationError);
		}
		
		public function test_setVerifyError_doesNotThrowError() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			// Don't expect an error, but don't expect a change in state either
			recordState.setVerifyError(new Error());
		}
		
		public function test_canReplay_alwaysReturnsTrue() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			assertTrue(recordState.canReplay);
		}
		
		public function testReplay_lastMethodNotClosed() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			assertExpectationNotClosedError(recordState, function():void
			{
				recordState.replay();
			});
		}
		
		public function testReplay_lastMethodClosed() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			recordState.lastExpectation = setupLastExpectation(true);
			
			var state : IMockState = recordState.replay();
			
			assertTrue("Unexpected result from replay()", state is StrictReplayMockState);
		}
		
		public function testReplay_noLastMethod() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			var state : IMockState = recordState.replay();
			
			assertTrue("Unexpected result from replay()", state is StrictReplayMockState);
		}
		
		public function test_backToRecord_returnsClonedStrictRecordMockState() : void
		{
			var recordState : StrictRecordMockState = new StrictRecordMockState(_mockObject, _mockRepository);
			
			var newMockState : IMockState = recordState.backToRecord();
			
			assertTrue("Expected new instance from backToRecord", newMockState is StrictRecordMockState);
			assertNotStrictlyEquals(recordState, newMockState, "Expected new instance from backToRecord");
			
			assertStrictlyEquals("Unexpected proxy value on new instance", _mockObject, (newMockState as StrictRecordMockState).proxy);
			assertStrictlyEquals("Unexpected lastExpectation value on new instance", _mockRepository, (newMockState as StrictRecordMockState).repository);
			assertNull("Unexpected lastExpectation value on new instance", (newMockState as StrictRecordMockState).lastExpectation);
		}
		
		private function assertExpectationNotClosedError(state : StrictRecordMockState, func : Function) : void
		{
			var expectation : MockExpectation = setupLastExpectation(false);
			var expectedErrorMessage : String = "test message";
			
			expectation.mock.setupResult("get_errorMessage", expectedErrorMessage);
			
			state.lastExpectation = expectation;
			
			var err : Error = assertError(null, func, IllegalOperationError);
			
			assertTrue("Unexpected error message", err.message.indexOf(expectedErrorMessage) > -1);
		}
		
		private function setupLastExpectation(actionsSatisfied : Boolean) : MockExpectation
		{
			var expectation : MockExpectation = new MockExpectation();
			expectation.mock.setupResult("actionsSatisfied", actionsSatisfied);
			
			return expectation;
		}
		
	}
}