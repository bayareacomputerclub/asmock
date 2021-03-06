package asmock.tests.framework.impl.dynamicMock
{
	import asmock.tests.framework.impl.*;
	import asmock.framework.impl.IMockState;
	import asmock.framework.impl.dynamicMock.*;
	import asmock.reflection.MethodInfo;
	import asmock.reflection.Type;
	import asmock.tests.ExtendedTestCase;
	import asmock.tests.framework.MockInvocation;
	
	import flash.errors.IllegalOperationError;
	
	public class DynamicVerifiedMockStateFixture extends ExtendedTestCase
	{
		public function DynamicVerifiedMockStateFixture()
		{
		}
		
		public function test_getLastMethodOptions_throwsError() : void
		{
			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(new MockMockState());
			
			assertError(null, function():void
			{
				state.getLastMethodOptions();
			}, IllegalOperationError);
		}
		
		public function test_backToRecord_returnsPreviousRecordState() : void
		{
			var expectedState : IMockState = new MockMockState();
			
			var mockRecordState : MockMockState = new MockMockState();
			mockRecordState.mock.setupResult("backToRecord", expectedState);
			
			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(mockRecordState);
			
			var actualState : IMockState = state.backToRecord();
			
			assertStrictlyEquals("Unexpected return value from backToRecord", expectedState, actualState);
		}
		
		public function test_canReplay_alwaysReturnsFalse() : void
		{
			var mockRecordState : MockMockState = new MockMockState();

			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(mockRecordState);
			
			assertFalse(state.canReplay);
		}
		
		public function test_replay_throwsError() : void
		{
			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(new MockMockState());
			
			assertError(null, function():void
			{
				state.replay();
			}, IllegalOperationError);
			
		}
		
		public function test_canVerify_alwaysReturnsFalse() : void
		{
			var mockRecordState : MockMockState = new MockMockState();

			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(mockRecordState);
			
			assertFalse(state.canVerify);
		}
		
		public function test_verify_throwsError() : void
		{
			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(new MockMockState());
			
			assertError(null, function():void
			{
				state.verify();
			}, IllegalOperationError);
		}
		
		public function test_verifyState_throwsError() : void
		{
			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(new MockMockState());
			
			assertError(null, function():void
			{
				var result : IMockState = state.verifyState;
			}, IllegalOperationError);
		}
		
		public function test_methodCall_throwsError() : void
		{
			var method : MethodInfo = MethodInfo.getCallingMethod();
			
			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(new MockMockState());
			
			assertError(null, function():void
			{
				state.methodCall(new MockInvocation(), method, []);
			}, IllegalOperationError);
		}
		
		public function test_setVerifyError_doesNotThrowError() : void
		{
			var state : DynamicVerifiedMockState = new DynamicVerifiedMockState(new MockMockState());
			
			state.setVerifyError(new Error());
		}

	}
}