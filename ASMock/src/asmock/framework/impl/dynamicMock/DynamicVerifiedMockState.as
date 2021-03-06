package asmock.framework.impl.dynamicMock
{
	import asmock.framework.IMethodOptions;
	import asmock.framework.impl.IMockState;
	import asmock.framework.proxy.IInvocation;
	import asmock.reflection.MethodInfo;
	
	import flash.errors.IllegalOperationError;
	
	[ExcludeClass]
	public class DynamicVerifiedMockState implements IMockState
	{
		private var _previous : IMockState;
		
		public function DynamicVerifiedMockState(previous : IMockState)
		{
			_previous = previous;
		}
		
		public function getLastMethodOptions() : IMethodOptions
		{
			throw invalidInVerifiedState();
		}
		
		public function backToRecord() : IMockState
		{
			return this._previous.backToRecord();
		}
		
		public final function get canReplay() : Boolean
		{
			return false;
		}
		
		public function replay() : IMockState
		{
			throw invalidInVerifiedState();
		}
		
		public function get canVerify() : Boolean
		{
			return false;
		}
		
		public function verify() : void
		{
			throw invalidInVerifiedState();
		}
		
		public function get verifyState() : IMockState
		{
			throw invalidInVerifiedState();
		}
		
		public function methodCall(invocation : IInvocation, method : MethodInfo, args : Array) : Object
		{
			throw invalidInVerifiedState();
		}
		
		public function setVerifyError(error : Error) : void
		{
		}

		private function invalidInVerifiedState() : Error
		{
			return new IllegalOperationError("This action is invalid when the mock object is in verified state.");
		}
	}
}