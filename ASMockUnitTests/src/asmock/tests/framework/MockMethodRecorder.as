package asmock.tests.framework
{
	import asmock.framework.ExpectationViolationError;
	import asmock.framework.expectations.IExpectation;
	import asmock.framework.impl.IMethodRecorder;
	import asmock.framework.proxy.IInvocation;
	import asmock.reflection.MethodInfo;
	import asmock.tests.SimpleMock;
	
	public class MockMethodRecorder implements IMethodRecorder
	{
		public function MockMethodRecorder()
		{
		}
		
		public function addRecorder(recorder : IMethodRecorder) : void
		{
			_mock.exec("addRecorder", [recorder]);
		}
		
		public function moveToParentReplayer() : void
		{
			_mock.exec("moveToParentReplayer");
		}
		
		public function moveToPreviousRecorder() : Boolean
		{
			return _mock.exec("moveToPreviousRecorder") as Boolean;
		}
		
		public function clearReplayerToCall(childReplayer : IMethodRecorder) : void
		{
			_mock.exec("clearReplayerToCall", [childReplayer]);
		}
		
		public function addToRepeatableMethods(proxy : Object, method : MethodInfo, expectation : IExpectation) : void
		{
			_mock.exec("addToRepeatableMethods", [proxy, method, expectation]);
		}
		
		public function getRepeatableExpectation(proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			return _mock.exec("getRepeatableExpectation", [proxy, method, args]) as IExpectation;
		}
		
		public function removeAllRepeatableExpectationsForProxy(proxy : Object) : void
		{
			_mock.exec("removeAllRepeatableExpectationsForProxy", [proxy]);
		}
		
		public function getExpectedCallsMessage():String
		{
			return _mock.exec("getExpectedCallsMessage") as String;
		}
		
		public function removeExpectation(expectation : IExpectation) : void
		{
			_mock.exec("removeExpectation", [expectation]);
		}
		
		public function unexpectedMethodCall(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : ExpectationViolationError 
		{
			return _mock.exec("unexpectedMethodCall", [invocation, proxy, method, args]) as ExpectationViolationError;
		}
		
		public function record(proxy : Object, method : MethodInfo, expectation : IExpectation) : void
		{
			_mock.exec("record", [proxy, method, expectation]); 
		}
		
		public function getRecordedExpectation(invocation : IInvocation, proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			return _mock.exec("getRecordedExpectation", [invocation, proxy, method, args]) as IExpectation;
		}
		
		public function getRecordedExpectationOrNull(proxy : Object, method : MethodInfo, args : Array) : IExpectation
		{
			return _mock.exec("getRecordedExpectationOrNull", [proxy, method, args]) as IExpectation;
		}
		
		public function getAllExpectationsForProxy(proxy : Object) : Array
		{
			return _mock.exec("getAllExpectationsForProxy", [proxy]) as Array;
		}
		
		public function getAllExpectationsForProxyAndMethod(proxy : Object, method : MethodInfo) : Array
		{
			return _mock.exec("getAllExpectationsForProxyAndMethod", [proxy, method]) as Array;
		}
		
		public function replaceExpectation(proxy : Object, method : MethodInfo, oldExpectation : IExpectation, newExpectation : IExpectation) : void
		{
			_mock.exec("replaceExpectation", [proxy, method, oldExpectation, newExpectation]);
		}
		
		public function get hasExpectations() : Boolean
		{
			return _mock.exec("hasExpectations") as Boolean;
		}
		
		private var _mock : SimpleMock = new SimpleMock(this);
		public function get mock() : SimpleMock
		{
			return _mock;
		}

	}
}