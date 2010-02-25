package asmock.tests.framework.impl.strict
{
	import asmock.framework.ExpectationViolationError;
	import asmock.framework.impl.IMockState;
	import asmock.framework.impl.strict.StrictRecordMockState;
	import asmock.framework.impl.strict.StrictReplayMockState;
	import asmock.framework.impl.strict.StrictVerifiedMockState;
	import asmock.reflection.MethodInfo;
	import asmock.tests.ExtendedTestCase;
	import asmock.tests.framework.MockInvocation;
	import asmock.tests.framework.MockMethodRecorder;
	import asmock.tests.framework.MockMockRepository;
	import asmock.tests.framework.expectations.MockExpectation;
	
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.Assert;

	public class StrictReplayMockStateFixture extends ExtendedTestCase
	{
		private var _mockObject : Object = new Object();
		private var _mockRepository : MockMockRepository = new MockMockRepository();
		private var _previousState : StrictRecordMockState;
		
		public function StrictReplayMockStateFixture()
		{
			super();
			
			_previousState = new StrictRecordMockState(_mockObject, _mockRepository);
		}
		
		public override function setUp():void
		{
			_mockRepository.mock.reset();
		}
		
		public function test_getLastMethodOptions_throwsError() : void
		{
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			assertError(null, function():void
			{
				state.getLastMethodOptions();
			}, IllegalOperationError);
		}
		
		public function test_backToRecord_returnsPreviousState() : void
		{
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			var newRecordState : StrictRecordMockState = state.backToRecord() as StrictRecordMockState;
			
			assertNotNull("Unexpected results from backToRecord()", newRecordState);
			assertNotStrictlyEquals(_previousState, newRecordState, "Did not expect original state");
			
			assertStrictlyEquals("Expected repository to be passed over", _mockRepository, newRecordState.repository);
			assertStrictlyEquals("Expected proxy to be passed over", _mockObject, newRecordState.proxy);
		}
		
		public function test_canReplay_alwaysReturnsFalse() : void
		{
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			assertFalse(state.canReplay);
		}
		
		public function test_replay_throwsError() : void
		{
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			assertError(null, function():void
			{
				state.replay();
			}, IllegalOperationError);
		}
		
		public function test_canVerify_alwaysReturnsTrue() : void
		{
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			assertTrue(state.canVerify);
		}
		
		public function test_verify_noUnsatisfiedExpectations_doesNotThrowError() : void
		{
			var expectationA : MockExpectation = new MockExpectation();
			var expectationB : MockExpectation = new MockExpectation();
			var expectationC : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("expectationSatisfied", true);
			expectationB.mock.setupResult("expectationSatisfied", true);
			expectationC.mock.setupResult("expectationSatisfied", true);
			
			var recorder : MockMethodRecorder = new MockMethodRecorder();
			recorder.mock.setupResult("getAllExpectationsForProxy", [expectationA, expectationB, expectationC]);
			
			_mockRepository.mock.setupResult("recorder", recorder);
			
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			state.verify();
		}
		
		public function test_verify_unsatisfiedExpectations_throwsError() : void
		{
			var expectationA : MockExpectation = new MockExpectation();
			var expectationB : MockExpectation = new MockExpectation();
			var expectationC : MockExpectation = new MockExpectation();
			
			expectationA.mock.setupResult("buildVerificationFailureMessage", "message A");
			expectationA.mock.setupResult("expectationSatisfied", false);

			expectationB.mock.setupResult("expectationSatisfied", true);

			expectationC.mock.setupResult("buildVerificationFailureMessage", "message C");
			expectationC.mock.setupResult("expectationSatisfied", false);
			
			var recorder : MockMethodRecorder = new MockMethodRecorder();
			recorder.mock.setupResult("getAllExpectationsForProxy", [expectationA, expectationB, expectationC]);
			
			_mockRepository.mock.setupResult("recorder", recorder);
			
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			assertError("Expected error to be thrown", function():void
			{
				state.verify();
			}, ExpectationViolationError, "message A\nmessage C");
		}
		
		public function test_verify_verifyErrorSet_throwsError() : void
		{
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			var expectedError : Error = new Error();
			
			state.setVerifyError(expectedError);
			
			var actualError : Error = assertError(null, function():void
			{
				state.verify();
			});
			
			assertStrictlyEquals("Unexpected error thrown", expectedError, actualError);
		}
		
		public function test_methodCall_repeatableMethodNotNull_executesRepeatableMethod() : void
		{
			var expectedReturnValue : String = "test return value";
			var unexpectedReturnValue : String = "something else";
			
			var invocation : MockInvocation = new MockInvocation();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [1, "two"];
			
			var mockRepeatableExpectation : MockExpectation = new MockExpectation();
			mockRepeatableExpectation.mock.setupResult("returnOrThrow", expectedReturnValue);
			
			var mockRecordedExpectation : MockExpectation = new MockExpectation();
			mockRecordedExpectation.mock.setupResult("returnOrThrow", unexpectedReturnValue);
						
			var recorder : MockMethodRecorder = new MockMethodRecorder();
			recorder.mock.setupResult("getRecordedExpectation", mockRecordedExpectation);
			recorder.mock.setupResult("getRepeatableExpectation", mockRepeatableExpectation);
			
			_mockRepository.mock.setupResult("replayer", recorder);
			
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			var actualReturnValue : Object = state.methodCall(invocation, method, args);
			
			assertEquals("Unexpected return value", expectedReturnValue, actualReturnValue);
		}
		
		public function test_methodCall_repeatableMethodNull_recordedExpectationNotNull_executesExpectation() : void
		{
			var expectedReturnValue : String = "test return value";
			
			var invocation : MockInvocation = new MockInvocation();
			var method : MethodInfo = MethodInfo.getCallingMethod();
			var args : Array = [1, "two"];
			
			var mockExpectation : MockExpectation = new MockExpectation();
			mockExpectation.mock.setupResult("returnOrThrow", expectedReturnValue);
						
			var recorder : MockMethodRecorder = new MockMethodRecorder();
			recorder.mock.setupResult("getRecordedExpectation", mockExpectation);
			recorder.mock.setupResult("getRepeatableExpectation", null);
			
			_mockRepository.mock.setupResult("replayer", recorder);
			
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			var actualReturnValue : Object = state.methodCall(invocation, method, args);
			
			assertEquals("Unexpected return value", expectedReturnValue, actualReturnValue);
		}
		
		public function test_verifyState_returnsStrictVerifiedMockState() : void
		{
			var state : StrictReplayMockState = new StrictReplayMockState(_previousState);
			
			var verifyState : IMockState = state.verifyState;
			
			assertNotNull(verifyState);
			assertTrue(verifyState is StrictVerifiedMockState);
		}
	}
}