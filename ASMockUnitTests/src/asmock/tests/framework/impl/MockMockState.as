package asmock.tests.framework.impl
{
	import asmock.framework.IMethodOptions;
	import asmock.framework.impl.IMockState;
	import asmock.framework.proxy.IInvocation;
	import asmock.reflection.MethodInfo;
	import asmock.tests.SimpleMock;

	public class MockMockState implements IMockState
	{
		public function MockMockState()
		{
		}

		public function backToRecord():IMockState
		{
			return _mock.exec("backToRecord") as IMockState; 
		}
		
		public function get canReplay():Boolean
		{
			return _mock.exec("canReplay") as Boolean;
		}
		
		public function replay():IMockState
		{
			return _mock.exec("replay") as IMockState;
		}
		
		public function get canVerify():Boolean
		{
			return _mock.exec("canVerify") as Boolean;
		}
		
		public function verify():void
		{
			_mock.exec("verify");
		}
		
		public function get verifyState():IMockState
		{
			return _mock.exec("verifyState") as IMockState;
		}
		
		public function methodCall(invocation:IInvocation, method:MethodInfo, args:Array):Object
		{
			return _mock.exec("methodCall", [invocation, method, args]) as Object;
		}
		
		public function setVerifyError(error:Error):void
		{
			_mock.exec("setVerifyError", [error]);
		}
		
		public function getLastMethodOptions():IMethodOptions
		{
			return _mock.exec("getLastMethodOptions") as IMethodOptions;
		}
		
		private var _mock : SimpleMock = new SimpleMock(this);
		public function get mock() : SimpleMock
		{
			return _mock;
		}
		
	}
}